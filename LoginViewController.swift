//
//  ViewController.swift
//  JournalApp
//
//  Created by Vanessa Latefa Pampilo on 5/9/19.
//  Copyright © 2019 Vanessa Latefa Pampilo. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let manager = LoginManager()
        
        manager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            
            switch result {
                
            case .cancelled:
                print("User Cancelled")
                break
            case .success(let grantedPermissions, let declinedPermissions, let token):
                
                print("Success: \(token.userId.debugDescription)")
                print("Logged in")
                print(declinedPermissions)
                print(grantedPermissions)
                self.showUserInfo(token: token)
              //  self.performSegue(withIdentifier: "notetablesegue", sender: self)
                
                
            case .failed(let error):
                print("Login failed with error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    func showUserInfo(token: AccessToken){
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, picture.type(large)"], accessToken: token, httpMethod: .GET, apiVersion: .defaultVersion)
        
        connection.add(request){
            response, result in
            
            print("Response: \(response.debugDescription)")
            switch result {
            case .success(response: let response):
                if let email = response.dictionaryValue!["email"]{
                    print("email: \(email)")
                }
                self.performSegue(withIdentifier: "notetablesegue", sender: self)
                
                break
            case .failed(let error):
                print("error \(error.localizedDescription)")
                break
            }
        }
        connection.start()
    }
    

}

