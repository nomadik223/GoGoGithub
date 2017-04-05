//
//  Repository.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/4/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import Foundation

class Repository {
    let name : String?
    let description : String?
    let language : String?
    
    init?(json: [String : Any]) {
        self.name = json["name"] as? String
        self.description = json["description"] as? String
        self.language = json["language"] as? String
        
    }
}
