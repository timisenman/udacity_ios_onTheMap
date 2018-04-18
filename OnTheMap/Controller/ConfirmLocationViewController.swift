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
    
    var student: [Student?] = [Student]()
    var annotations = [MKPointAnnotation]()
    
    var newLocation: String?
    var newWebsite: String?
    var newLong: Double?
    var newLat: Double?
    
    override func viewWillAppear(_ animated: Bool) {
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
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.PostStudentData)!)
        request.httpMethod = "POST"
        request.addValue(Constants.UdacityConstants.UdacityApplicationID, forHTTPHeaderField: Constants.UdacityConstants.UdacityAppIDHeader)
        request.addValue(Constants.UdacityConstants.UdacityAPIKey, forHTTPHeaderField: Constants.UdacityConstants.UdacityAPIKeyHeader)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)
        request.httpBody = "{\"uniqueKey\": \"\(loggedInUser["uniqueKey"]!)\", \"firstName\": \"\(loggedInUser["firstName"]!)\", \"lastName\": \"\(loggedInUser["lastName"]!)\",\"mapString\": \"\(newLocation!)\", \"mediaURL\": \"\(newWebsite!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            if (error == nil) {
                performUIUpdatesOnMain {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
    func setMapAnnotations(latitude: Double, longitude: Double) {
        
        let lat = CLLocationDegrees(latitude)
        let long = CLLocationDegrees(longitude)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.annotations.append(annotation)
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
