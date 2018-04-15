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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login View is up.")
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitLoginButton(_ sender: Any) {
        print("Credentials submitted")
        let url = URL(string:"https://www.udacity.com/api/session")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(accountTextField.text!)\", \"password\": \"\(passwordTextField.text!)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            print("Task has begun.")
            guard (error == nil) else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let json: [String:AnyObject]!
            do {
                json = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let accountData = json["account"] as? [String:AnyObject] else {
                print("No account data")
                return
            }
            
            guard let isRegistered = accountData["registered"] as? Int else {
                print("Account not registered")
                return
            }
            
            
            if isRegistered == 1 {
                print("This user is registered.")
                
                performUIUpdatesOnMain {
                    let tabVC: UITabBarController
                    tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(tabVC, animated: true, completion: nil)
                }
            } else {
                print("User credentials not recognized.")
            }
        }
        
        task.resume()
        print("Task complete.")
    }
}
