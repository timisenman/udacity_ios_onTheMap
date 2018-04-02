//
//  ViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/22/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class CellTableViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("hello, cells")
    }
    
    func downloadUserData() {
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            print("request started")
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            
            
            // create a queue from scratch
            let downloadQueue = DispatchQueue(label: "download", attributes: [])
            
            // call dispatch async to send a closure to the downloads queue
            downloadQueue.async { () -> Void in
                
                // download Data
                let newData = String(data: data!, encoding: .utf8)!
                
                // display it
//                DispatchQueue.main.async(execute: { () -> Void in
//                })
                print(newData)
            }
            
        }
        task.resume()
    }

    
}


