//
//  RepoViewController.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/4/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    var repos = [Repository]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        update()
    }
    
    func update() {
        GitHub.shared.getRepos { (repositories) in
            guard let unwrappedRepos = repositories else {return}
            
            OperationQueue.main.addOperation {
                self.repos = unwrappedRepos
                print("Repos found: \(self.repos.count)")
            }
            
        }
    }
    
}

extension RepoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I did it?")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoViewCell.identifier, for: indexPath) as! RepoViewCell
        
        let repo = self.repos[indexPath.row]
        
        cell.repoTableCellLabel.text = repo.name
        
        return cell
    }
}
