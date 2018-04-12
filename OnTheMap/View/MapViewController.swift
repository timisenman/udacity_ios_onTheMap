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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        downloadUserData()
        
        let location = CLLocationCoordinate2DMake(37.786576, -122.394411)
        let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        self.mapView.setRegion(mapRegion, animated: true)
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
    
    
    func downloadUserData() {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=10")!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("request started")
            if error != nil { // Handle error…
                return
            }
            print("\n\n\(String(data:data!, encoding: .utf8)!)\n\n")

            
        }
        task.resume()
    }
}
