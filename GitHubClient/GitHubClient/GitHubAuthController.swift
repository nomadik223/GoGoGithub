//
//  GitHubAuthController.swift
//  GitHubClient
//
//  Created by Kent Rogers on 4/3/17.
//  Copyright © 2017 Austin Rogers. All rights reserved.
//

import UIKit

class GitHubAuthController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.getAccessToken() != nil) {
            loginButtonOutlet.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBOutlet weak var loginButtonOutlet: UIButton!
    

    @IBAction func printTokenPressed(_ sender: Any) {
        
        print(String(describing: UserDefaults.standard.string(forKey: "access_token")))
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let parameters = ["scope" : "email,user,repo"]
        
        GitHub.shared.oAuthRequestWith(parameters: parameters)
        
        
    }
    
    func dismissAuthController() {
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
}
