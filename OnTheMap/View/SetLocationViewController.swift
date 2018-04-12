//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class SetLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var confirmLocButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationTextField.text = "Yo' City"
        self.websiteTextField.text = "https://timisenman.me/"

        // Do any additional setup after loading the view.
    }

    //Segue to ConfirmLocation View
    @IBAction func confirmDetails(_ sender: Any) {
        let vc: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
