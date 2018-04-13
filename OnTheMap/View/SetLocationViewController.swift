//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class SetLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var confirmLocButton: UIButton!
    @IBOutlet weak var exitSetLocationButton: UIBarButtonItem!
    
    let textField = TextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationTextField.text = "Yo' City"
        self.websiteTextField.text = "https://timisenman.me/"
        
        self.locationTextField.delegate = textField
        self.websiteTextField.delegate = textField

        // Do any additional setup after loading the view.
    }

    //Segue to ConfirmLocation View
    @IBAction func confirmDetails(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.confirmLocation, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.confirmLocation {
            let confirmDetails = segue.destination as! ConfirmLocationViewController
            confirmDetails.newLocation = locationTextField.text!
            confirmDetails.newWebsite = websiteTextField.text!
        }
    }
    
    
    @IBAction func exitSetLocationAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

}
