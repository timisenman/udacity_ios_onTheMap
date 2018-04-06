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
        
        let location = CLLocationCoordinate2DMake(37.786576, -122.394411)
        let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
        let mapRegion = MKCoordinateRegionMake(location, mapSpan)
        self.mapView.setRegion(mapRegion, animated: true)
    }

}
