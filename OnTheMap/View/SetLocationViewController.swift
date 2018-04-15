//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SetLocationViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var confirmLocButton: UIButton!
    @IBOutlet weak var exitSetLocationButton: UIBarButtonItem!
    
    let textField = TextFieldDelegate()
    let geocoder = CLGeocoder()
    var placemarks: [CLPlacemark?] = [CLPlacemark]()
    var selectedLat: Double?
    var selectedLong: Double?
    
    let locationPlaceholderText = "Place of Study"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationTextField.text = locationPlaceholderText
        self.websiteTextField.text = "Web Address"
        
        self.locationTextField.delegate = textField
        self.websiteTextField.delegate = textField

    }

    //Segue to ConfirmLocation View
    @IBAction func confirmDetails(_ sender: Any) {
        self.getAddressFromString()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.confirmLocation {
            let confirmDetails = segue.destination as! ConfirmLocationViewController
            confirmDetails.newLocation = locationTextField.text!
            confirmDetails.newWebsite = websiteTextField.text!
            confirmDetails.newLat = selectedLat
            confirmDetails.newLong = selectedLong
        }
    }
    
    
    @IBAction func exitSetLocationAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAddressFromString() {
        if locationTextField.text != locationPlaceholderText {
            geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
                guard (error == nil) else {
                    print("You've encountered an error getting the string: \(error!)")
                    return
                }
                
                guard let location = placemark else {
                    print("No placemark.")
                    return
                }
                
                var locCoordinates: CLLocation?
                locCoordinates = location.first?.location
                
                if let coordinates = locCoordinates {
                    performUIUpdatesOnMain {
                        let coordinate = coordinates.coordinate
                        self.selectedLong = Double(coordinate.longitude)
                        self.selectedLat = Double(coordinate.latitude)
                        self.performSegue(withIdentifier: Constants.Segues.confirmLocation, sender: self)
                    }
                } else {
                    print("Coordinates could not be set.")
                }
            }
        }
    }
}
