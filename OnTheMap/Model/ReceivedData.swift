//
//  ReceivedData.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/16/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation
import MapKit

class StudentArray {
    static let shared = StudentArray()
    var studentArray: [Student]? = [Student]()
    var studentAnnotations = [MKPointAnnotation]()
}

class UserArray {
    static let shared = UserArray()
    
    var loggedInAnnotations = [MKPointAnnotation]()
    
    var loggedInUser: [String:Any] = [
        Constants.LoggedInUser.firstName: "",
        Constants.LoggedInUser.lastName: "",
        Constants.LoggedInUser.sessionId: "",
        Constants.LoggedInUser.objectId: "",
        Constants.LoggedInUser.uniqueKey: "",
        Constants.LoggedInUser.mediaURL: "",
        Constants.LoggedInUser.location: "",
        Constants.LoggedInUser.latitude: 0.0,
        Constants.LoggedInUser.longitude: 0.0,
        Constants.LoggedInUser.createdAt: ""
    ]
    
    var logoutData = [String:AnyObject]()
}
