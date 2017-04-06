//
//  Repository.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/4/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import Foundation

class Repository {
    let name : String
    let description : String?
    let language : String?
    let stars : String?
    let createdAt : String?
    let forked : Bool?
    
    init?(json: [String : Any]) {
        if let name = json["name"] as? String {
            self.name = name
        } else {
            self.name = "No Name"
        }
        self.description = json["description"] as? String ?? "No description"
        self.language = json["language"] as? String ?? "Undefined language"
        self.stars = json["stargazers_count"] as? String ?? "No Stars"
        self.createdAt = (json["created_at"] as? String)?.components(separatedBy: "T").first
        self.forked = json["fork"] as? Bool
        
    }
}






