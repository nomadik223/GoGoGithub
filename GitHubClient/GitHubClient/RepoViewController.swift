//
//  RepoViewController.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/4/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()

        // Do any additional setup after loading the view.
    }
    
    func update() {
        
        GitHub.shared.getRepos { (repositories) in
            print(repositories?.first)
            //update tableView
            
        }
        
    }

}
