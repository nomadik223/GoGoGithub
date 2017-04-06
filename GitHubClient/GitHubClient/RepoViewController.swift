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
    
    var displayRepos : [Repository]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: RepoTableViewCell.identifier, bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: RepoTableViewCell.identifier)
        
        update()
    }
    
    func update() {
        
        GitHub.shared.getRepos { (repositories) in
            guard let unwrappedRepos = repositories else {return}
            
            OperationQueue.main.addOperation {
                self.repos = unwrappedRepos
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == RepoDetailViewController.identifier {
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row {
                let selectedRepo = self.repos[selectedIndex]
                guard let destinationController = segue.destination as? RepoDetailViewController else {return}
                destinationController.repo = selectedRepo
            }
            segue.destination.transitioningDelegate = self as? UIViewControllerTransitioningDelegate
        }
    }
    
}

//MARK: RepoViewController Transitioning Delegate
extension RepoDetailViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return CustomTransition(duration: 1.0)
        
    }
}

//MARK: RepoViewController Delegate and DataSource
extension RepoViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: RepoDetailViewController.identifier, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        
        let repo = self.repos[indexPath.row]
        
        cell.RepoTableCellLabel.text = repo.name
        cell.RepoDescriptionLabel.text = repo.description
        cell.RepoLanguageLabel.text = repo.language
        
        
        return cell
    }
}

extension RepoViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchedText = searchBar.text {
            self.displayRepos = self.repos.filter({($0.name.contains(searchedText))})
        }
        
        if searchBar.text == "" {
            self.displayRepos = nil
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.displayRepos = nil
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
    }
    
}
