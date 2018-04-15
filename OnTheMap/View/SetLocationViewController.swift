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
        print("View has loaded.")
        
        self.locationTextField.text = locationPlaceholderText
        self.websiteTextField.text = "Web Address"
        
        self.locationTextField.delegate = textField
        self.websiteTextField.delegate = textField

    }

    //Segue to ConfirmLocation View
    @IBAction func confirmDetails(_ sender: Any) {
        print("Confirm button pressed.")
        print("Getting new address from String.")
        self.getAddressFromString()
        performSegue(withIdentifier: Constants.Segues.confirmLocation, sender: self)
    }
    
    @IBAction func exitSetLocationAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAddressFromString() {
        print("Getting address from string.")
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
                print("\nLocation from first location of Placemark:\n\(locCoordinates!))")
                
                if let coordinates = locCoordinates {
                    performUIUpdatesOnMain {
                        let coordinate = coordinates.coordinate
                        print("\nLatitude: \(coordinate.latitude)")
                        print("Longitude: \(coordinate.longitude)")
                        self.selectedLong = Double(coordinate.longitude)
                        self.selectedLat = Double(coordinate.latitude)
                        print("New Lat/Long assigned.")
                        print("New lat, long:\(self.selectedLat), \(self.selectedLong) ")
                    }
                } else {
                    print("Coordinates could not be set.")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\nPREPARING FOR SEGUE\n")
        if segue.identifier == Constants.Segues.confirmLocation {
            print("Setting segue variables")
            let confirmDetails = segue.destination as! ConfirmLocationViewController
            confirmDetails.newLocation = locationTextField.text!
            confirmDetails.newWebsite = websiteTextField.text!
            print("Attempting to set new Lat/Long")
            confirmDetails.newLat = selectedLat
            confirmDetails.newLong = selectedLong
        }
    }
}
