//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/29/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpText: UITextView!
    
    @IBAction func submitLoginButton(_ sender: Any) {
        let url = URL(string: Constants.UdacityConstants.UdacitySession)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderAccept)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)
        request.httpBody = "{\"udacity\": {\"username\": \"\(accountTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        
        OTMClient.sharedInstance().login(request: request) { (accountData, sessionId, isRegistered) in
            if isRegistered == 1 {
                //Attempting to set global variables
                loggedInUser["id"] = sessionId
                loggedInUser["uniqueKey"] = String(describing: accountData["key"]!)
                print("\nLogged in User Data: \(loggedInUser)\n")
                
                performUIUpdatesOnMain {
                    let tabVC: UITabBarController
                    tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(tabVC, animated: true, completion: nil)
                }
            } else {
                print("User credentials not recognized.")
                //Need Warning prompt that the credentials were invalid
            }
            
            if let uniqueKey = loggedInUser["uniqueKey"] {
                OTMClient.sharedInstance().taskForLoggedInStudentData(ofStudent: uniqueKey) { (firstName, lastName) in
                    loggedInUser["firstName"] = firstName
                    loggedInUser["lastName"] = lastName
                    print("Logged in data after successful login: \(loggedInUser)")
                }
            }
        }
    }
    
    
    
    @IBAction func signUpAction(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: Constants.UdacityConstants.SignUpFormURL)!, options: [:]) { (success) in
            return
        }
    }
}
