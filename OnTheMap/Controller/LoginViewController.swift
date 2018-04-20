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
        OTMClient.sharedInstance().loginWith(userName: accountTextField.text!, password: passwordTextField.text!) { (success, errorString) in
            if success {
                self.completeLogin()
            } else {
                self.displayError(withString: errorString!)
            }
        }
    }
    
    func completeLogin() {
        performUIUpdatesOnMain {
            let tabVC: UITabBarController
            tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            self.present(tabVC, animated: true, completion: nil)
        }
    }
    
    func displayError(withString: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Oops!", message: withString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let app = UIApplication.shared
        app.open(URL(string: Constants.UdacityConstants.SignUpFormURL)!, options: [:]) { (success) in
            return
        }
    }
}
