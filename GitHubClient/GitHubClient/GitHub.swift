//
//  GitHub.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/3/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

let kOAuthBaseURLString = "https://github.com/login/oauth/"


typealias GitHubOAuthCompletion = (SaveOptions, Bool)->()
typealias FetchReposCompletion = ([Repository]?)->()

enum GitHubAuthError : Error {
    case extractingCode
}

enum SaveOptions {
    case UserDefaults(String?)
}



class GitHub {
    
    private var session: URLSession
    private var components: URLComponents
    
    static let shared = GitHub()
    
    private init() {
        
        self.session = URLSession(configuration: .default)
        self.components = URLComponents()
        
        self.components.scheme = "https"
        self.components.host = "api.github.com"
        
    }
    
    func oAuthRequestWith(parameters: [String : String]) {
        var parametersString = ""
        
        for (key, value) in parameters {
            parametersString += "&\(key)=\(value)"
        }
        
        if let requestURL = URL(string: "\(kOAuthBaseURLString)authorize?client_id=\(gitHubClientID)\(parametersString)") {
            
            print(requestURL.absoluteString)
            
            UIApplication.shared.open(requestURL)
            
        }
        
    }
    
    func getCodeFrom(url: URL) throws -> String {
        
        guard let code = url.absoluteString.components(separatedBy: "=").last else { throw GitHubAuthError.extractingCode }
        
        return code
        
    }
    
    func tokenRequestFor(url: URL, saveOptions: SaveOptions, completion: @escaping GitHubOAuthCompletion) {
        
        func complete(success: Bool) {
            OperationQueue.main.addOperation {
                completion(saveOptions, success)
            }
        }
        
        do {
            let code = try self.getCodeFrom(url: url)
            
            let requestString = "\(kOAuthBaseURLString)access_token?client_id=\(gitHubClientID)&client_secret=\(gitHubClientSecret)&code=\(code)"
            
            if let requestURL = URL(string: requestString) {
                
                let session = URLSession(configuration: .default)
                
                session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                    
                    if error != nil { complete(success: false) }
                    
                    guard let data = data else { complete(success: false); return }
                    
                    guard let dataString = String(data: data, encoding: .utf8) else { complete(success: false); return }
                    
                    guard let accessToken = dataString.components(separatedBy: "&").first?.components(separatedBy: "=").last else { complete(success: false); return }
                    
                    complete(success: UserDefaults.standard.save(accessToken: accessToken))
                    
                }).resume()
                
            }
            
        } catch {
            print(error)
            complete(success: false)
        }
        
        
    }
    
    func getRepos(completion: @escaping FetchReposCompletion) {
        
        if let token = UserDefaults.standard.getAccessToken() {
            let queryItem = URLQueryItem(name: "access_token", value: token)
            self.components.queryItems = [queryItem]
        }
        
        func returnToMain(results: [Repository]?) {
            OperationQueue.main.addOperation {
                completion(results)
            }
        }
        
        self.components.path = "/user/repos"
        
        guard let url = self.components.url else { returnToMain(results: nil); return }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            if error != nil { returnToMain(results: nil); return }
            
            if let data = data {
                
                var repositories = [Repository]()
                
                do {
                    if let rootJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [[String : Any]]{
                        for repositoryJSON in rootJson {
                            if let repo = Repository(json: repositoryJSON){
                                repositories.append(repo)
                            }
                        }
                        
                        returnToMain(results: repositories)
                        
                    }
                } catch {
                    
                }
                
            }
            
            }.resume()
        
    }
    
}

