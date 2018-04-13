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
    
    var students: [Student] = [Student]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        downloadUserData()
        setMapAnnotations()
        configureMap()
    }
    
    func downloadUserData() {
        print("DOWNLOADING USER DATA")
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=5")!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("request started")
            if error != nil { // Handle error…
                return
            }
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let studentDictionary = results["results"] as? [[String:AnyObject]] else {
                print("Not dictionary.")
                return
            }
            
            self.students = Student.studentsFromRequest(studentDictionary)
            
            print("Printing students after parsing: \(self.students)")
            print("\nTask beginning\n")
            
            //Attempting to add annotations to map here:
//            performUIUpdatesOnMain {
//                self.mapView.addAnnotations(self.annotations)
//            }
            
        }
        task.resume()
        print("Printing Students after task:\n\(self.students)")
    }
    
    func setMapAnnotations() {
        print("Setting annotations in ViewWillAppear")
        print("Printing students during Annotation setup: \(students)")
        
        for student in students {
            
            print("Student:\n\(student)")
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = student.firstName + " " + student.lastName
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
            print("Annotations sent to dictionary.")
            
            print("Attempting to add annotions directly, one at a time")
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func configureMap() {
        print("CONFIGURING MAP")
        let location = CLLocationCoordinate2DMake(37.786576, -122.394411)
        let mapSpan = MKCoordinateSpanMake(25.0, 25.0)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        let _ = MKUserLocation()
        self.mapView.setRegion(mapRegion, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
        
        let loginVC: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! UIViewController
        self.present(loginVC, animated: true, completion: nil)

    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        print("\nmapView viewFor has begun\n")
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
        print("\nmapView annotationView has begun\n")
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    print("URL opened successfully.")
                }
            }
        }
    }
}
