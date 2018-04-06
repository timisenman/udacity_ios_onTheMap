//
//  StudentData.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/29/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

struct StudentInfo {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String

    init?(dictionary: [String:Any]) {
        self.firstName = dictionary["firstName"] as? String ?? ""
        self.lastName = dictionary["lastName"] as? String ?? ""
        self.uniqueKey = dictionary["uniqueKey"] as? String ?? ""
        self.objectId = dictionary["objectId"] as? String ?? ""
        self.mapString = dictionary["mapString"] as? String ?? ""
        self.mediaURL = dictionary["mediaURL"] as? String ?? ""
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
        self.createdAt = dictionary["createdAt"] as? String ?? ""
        self.updatedAt = dictionary["updatedAt"] as? String ?? ""

    }
}

