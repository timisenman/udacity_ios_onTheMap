//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/6/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var confirmLocationButton: UIButton!
    
    var newLocation: String?
    var newWebsite: String?
    var newLong: Double?
    var newLat: Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let lat = newLat, let long = newLong {
            setMapAnnotations(latitude: lat, longitude: long)
            configureMap(latitude: lat, longitude: long)
        }
    }
    
    func configureMap(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let mapSpan = MKCoordinateSpanMake(5.0, 5.0)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
    @IBAction func confirmLocationAction(_ sender: Any) {
        saveUsersInformation()
        OTMClient.sharedInstance().postStudentLocation() { success, errorString in
            if success {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                self.displayError(title: "Oops", message: "There was a problem posting your location. Try again.")
            }
        }
    }
    
    func setMapAnnotations(latitude: Double, longitude: Double) {
        
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(UserArray.shared.loggedInUser[Constants.LoggedInUser.firstName]!) \(UserArray.shared.loggedInUser[Constants.LoggedInUser.lastName]!)"
        annotation.subtitle = "\(UserArray.shared.loggedInUser[Constants.LoggedInUser.mediaURL]!)"
        
        UserArray.shared.loggedInAnnotations.append(annotation)
        self.mapView.addAnnotations(UserArray.shared.loggedInAnnotations)
    }
    
    func saveUsersInformation() {
        UserArray.shared.loggedInUser[Constants.LoggedInUser.latitude] = newLat
        UserArray.shared.loggedInUser[Constants.LoggedInUser.longitude] = newLong
        UserArray.shared.loggedInUser[Constants.LoggedInUser.mediaURL] = newWebsite
        UserArray.shared.loggedInUser[Constants.LoggedInUser.location] = newLocation
    }
    
    func displayError(title: String, message: String) {
        let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }    
}
