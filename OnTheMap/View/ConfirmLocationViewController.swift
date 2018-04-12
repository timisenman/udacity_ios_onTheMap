//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var confirmLocationMap: MKMapView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    
    //Show geocoded location
    //POST/PUT Request
    //Dismiss view

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func confirmLocationAction(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Tim\", \"lastName\": \"Isenman\",\"mapString\": \"San Francisco, CA\", \"mediaURL\": \"https://apple.com/\",\"latitude\": 37.745192, \"longitude\": -122.439662}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            if (error == nil) {
                print("No error. Dismissing Confirmation View.")
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error!)
            }
        }
        task.resume()
        
        
    }
    
}
