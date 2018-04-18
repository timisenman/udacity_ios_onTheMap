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
    @IBOutlet weak var mapIcon: UIImageView!
    
    let textField = TextFieldDelegate()
    var activityIndicator = UIActivityIndicatorView()
    let geocoder = CLGeocoder()
    var placemarks: [CLPlacemark?] = [CLPlacemark]()
    var selectedLat: Double?
    var selectedLong: Double?
    
    //Usable when delegate is working
    let locationPlaceholderText = "Place of Study"
    let websitePlaceholderText = "Website"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.locationTextField.delegate = textField
        self.websiteTextField.delegate = textField
        self.mapIcon.isHidden = false
    }
    
    func configureActivityIndicator() {
        self.mapIcon.isHidden = true
        self.activityIndicator.center = self.mapIcon.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    @IBAction func confirmDetails(_ sender: Any) {
        if websiteTextField.text?.contains("https://") == false {
            self.presentWarningWith(title: "Oops!", message: "You need 'https://' in your address.")
        } else {
            configureActivityIndicator()
            self.getAddressFromString()
        }
    }
    
    @IBAction func exitSetLocationAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func presentWarningWith(title: String, message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
    
    func getAddressFromString() {
        if locationTextField.text != locationPlaceholderText {
            geocoder.geocodeAddressString(locationTextField.text!) { (placemark, error) in
                guard (error == nil) else {
                    self.presentWarningWith(title: "Oops", message: "You've encountered an error getting the string: \(error!)")
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
                        self.activityIndicator.stopAnimating()
                    }
                } else {
                    self.presentWarningWith(title: "Oops", message: "Your coordinates could not be set. Try again.")
                }
            }
        }
    }
}
