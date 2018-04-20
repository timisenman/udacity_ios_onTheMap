//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/31/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewToolBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var refreshDataButton: UIBarButtonItem!
    
    
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureMap()
        downloadUserData()
    }
    
    @IBAction func refreshDataAction(_ sender: Any) {
        downloadUserData()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.sharedInstance().logoutAndDeleteSession { (success, errorString, sessionData) in
            if success {
                logoutData = sessionData!
            } else {
                self.displayError(withString: errorString!)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadUserData() {
        OTMClient.sharedInstance().taskForGet() { (success, errorString) in
            if success {
                performUIUpdatesOnMain {
                    self.setMapAnnotations(students: studentArray!)
                }
            } else {
                self.displayError(withString: errorString!)
            }
        }
    }
    
    func setMapAnnotations(students: [Student]) {
        for student in students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            self.annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func configureMap() {
        let location = CLLocationCoordinate2DMake(37.786576, -122.394411)
        let mapSpan = MKCoordinateSpanMake(25.0, 25.0)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        self.mapView.setRegion(mapRegion, animated: true)
    }
    
    func displayError(withString: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Oops!", message: withString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            
            guard let toOpen = view.annotation?.subtitle! else {
                self.displayError(withString: "This isn't a valid URL.")
                return
            }
            if toOpen.contains("https://") == true {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if success {
                        print("URL opened successfully")
                    } else {
                        self.displayError(withString: "This isn't a valid URL.")
                    }
                }
            } else {
                self.displayError(withString: "This isn't a valid URL.")
            }
        }
    }
}
