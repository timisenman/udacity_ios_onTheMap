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
    
    let textFieldDelegate = TextFieldDelegate()
    var activityIndicator = UIActivityIndicatorView()
    let geocoder = CLGeocoder()
    var placemarks: [CLPlacemark?] = [CLPlacemark]()
    var selectedLat: Double?
    var selectedLong: Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationTextField.delegate = textFieldDelegate
        websiteTextField.delegate = self
        mapIcon.isHidden = false
    }
    
    @IBAction func confirmDetails(_ sender: Any) {
        if websiteTextField.text?.contains("https://") == true {
            configureActivityIndicator()
            self.getAddressFromString()
        } else {
            self.displayError(message: "You need 'https://' in your address.")
        }
    }
    
    @IBAction func exitSetLocationAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureActivityIndicator() {
        self.mapIcon.isHidden = true
        self.activityIndicator.center = self.mapIcon.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func displayError(message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.stopActivityIndicator()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        self.mapIcon.isHidden = false
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateText(textField)
    }
    
    func updateText(_ textField: UITextField) {
        if textField == websiteTextField {
            if websiteTextField.text == "" {
                websiteTextField.text = "https://"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    func getAddressFromString() {
        if let usersLocation = locationTextField.text {
            geocoder.geocodeAddressString(usersLocation) { (placemark, error) in
                guard (error == nil) else {
                    self.displayError(message: "Your location could not be found.")
                    return
                }
                
                guard let location = placemark else {
                    self.displayError(message: "There was a problem placing your pin on the map.")
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
                    self.displayError(message: "There was a problem placing your pin on the map.")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
