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

    @IBOutlet weak var mapViewToolBar: UIToolbar!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async(execute: { () -> Void in
            let location = CLLocationCoordinate2DMake(45.0, 100.0)
            
            let mapSpan = MKCoordinateSpanMake(0.01, 0.01)
            
            let mapRegion = MKCoordinateRegionMake(location, mapSpan)
            
            self.mapView.setRegion(mapRegion, animated: true)
        })
        
    }


}
