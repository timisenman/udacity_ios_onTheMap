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
    let tempLat = 35.689506
    let tempLong = 139.6917

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let lat = newLat, let long = newLong {
            setMapAnnotations(latitude: lat, longitude: long)
            configureMap(latitude: lat, longitude: long)
        }
    }
    
    //Pass in Student information from somewhere. After Login? During segue from Map or TableView? 
    
    func configureMap(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let mapSpan = MKCoordinateSpanMake(5.0, 5.0)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        self.mapView.setRegion(mapRegion, animated: true)
        print("Map is configured.")
        
    }
    
    @IBAction func confirmLocationAction(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"Tim\", \"lastName\": \"Isenman\",\"mapString\": \"\(newLocation!)\", \"mediaURL\": \"\(newWebsite!)\",\"latitude\": \(newLat!), \"longitude\": \(newLong!)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            if (error == nil) {
                print("No error. Dismissing Confirmation View.")
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
        print("Setting annotations in ViewWillAppear")
        
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
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
