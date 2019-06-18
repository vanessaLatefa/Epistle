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
        //this class provides methods for logging the user in and out
        let manager = LoginManager()
        
        //Logs the user in or authorizes additional permissions.
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
              
                
                
            case .failed(let error):
                print("Login failed with error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    //this function requests info from the FacebookAPI, grabs the info and then takes the reponse
    //my closure then accepts this info and runs its methods
    
    //AccessToken is the token used upon successful authorizations(or sets nil in case of log out)
    func showUserInfo(token: AccessToken){
        
        //Represents a single connection to Facebook to service a single or multiple requests.
        let connection = GraphRequestConnection()
        
        //is a protocol that Represents a request to the Facebook Graph API.
        let request = GraphRequest(graphPath: "/me", parameters: ["fields" : "id, email, picture.type(large)"], accessToken: token, httpMethod: .GET, apiVersion: .defaultVersion)
        
        //Adds a request object to this connection.
        connection.add(request){
            response, result in
            
            print("Response: \(response.debugDescription)")
            switch result {
                
            //when succesfully loggedin it will then performsegue to my tableView object
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
        
        //Starts a connection with the server and sends all the requests in this connection.
        connection.start()
    }
    

}

