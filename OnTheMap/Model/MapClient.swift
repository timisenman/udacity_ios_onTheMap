//
//  MapClient.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/26/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class MapClient: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
//    let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")
//    
//    var request = URLRequest(url: url!)
//    request.addValue(, forHTTPHeaderField: "X-Parse-Application-Id")
//    request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//    print(request)
//    
//    let task = session.dataTask(with: request) { data, response, error in
//        if error != nil { // Handle error...
//            return
//        }
//        print(String(data: data!, encoding: .utf8)!)
//    }
//    task.resume()

}
