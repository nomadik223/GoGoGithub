//
//  RepoDetailViewController.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/5/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

class RepoDetailViewController: UIViewController {

    @IBOutlet weak var repoDetailName: UILabel!
    @IBOutlet weak var repoDetailLanguage: UILabel!
    @IBOutlet weak var repoDetailDescription: UILabel!
    @IBOutlet weak var repoDetailStars: UILabel!
    @IBOutlet weak var repoDetailFork: UILabel!
    @IBOutlet weak var repoDetailCreated: UILabel!
    
    @IBAction func closeDetailController(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    var repo : Repository!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repoDetailName.text = repo.name
        self.repoDetailDescription.text = repo.description
        self.repoDetailLanguage.text = repo.language
        self.repoDetailStars.text = repo.stars
        if repo.forked! {
            self.repoDetailFork.isHidden = false
        } else {
            self.repoDetailFork.isHidden = true
        }
        self.repoDetailCreated.text = repo.createdAt
        
    }
    
}
