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
    
    var students: [Student]? = [Student]()
    var annotations = [MKPointAnnotation]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureMap()
        downloadUserData()
    }
    
    func downloadUserData() {
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.GetStudentData)!)
        request.httpMethod = "GET"
        request.addValue(Constants.UdacityConstants.UdacityApplicationID, forHTTPHeaderField: Constants.UdacityConstants.UdacityAppIDHeader)
        request.addValue(Constants.UdacityConstants.UdacityAPIKey, forHTTPHeaderField: Constants.UdacityConstants.UdacityAPIKeyHeader)
        
        OTMClient.sharedInstance().taskForGet(request: request) { (studentData) in
            performUIUpdatesOnMain {
                self.setMapAnnotations(students: studentData)
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
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.sharedInstance().logoutAndDeleteSession { (sessionData) in
            logoutData = sessionData
            print("\nLogging Out with: \(logoutData)\n")
        }
        self.dismiss(animated: true, completion: nil)
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
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    return
                }
            }
        }
    }
}
