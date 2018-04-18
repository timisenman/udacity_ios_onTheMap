//
//  Constants.StudentResponseKeys.ata.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/29/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

struct Student {
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
    
    init?(dictionary: [String:AnyObject]) {
        self.objectId = dictionary[Constants.StudentResponseKeys.objectKey] as? String ?? ""
        self.uniqueKey = dictionary[Constants.StudentResponseKeys.uniqueKeyKey] as? String ?? ""
        self.firstName = dictionary[Constants.StudentResponseKeys.firstNameKey] as? String ?? ""
        self.lastName = dictionary[Constants.StudentResponseKeys.lastNameKey] as? String ?? ""
        self.mapString = dictionary[Constants.StudentResponseKeys.mapStringKey] as? String ?? ""
        self.mediaURL = dictionary[Constants.StudentResponseKeys.mediaURLKey] as? String ?? ""
        self.latitude = dictionary[Constants.StudentResponseKeys.latitudeKey] as? Double ?? 0.0
        self.longitude = dictionary[Constants.StudentResponseKeys.longitudeKey] as? Double ?? 0.0
        self.createdAt = dictionary[Constants.StudentResponseKeys.createAtKey] as? String ?? ""
        self.updatedAt = dictionary[Constants.StudentResponseKeys.updatedAtKey] as? String ?? ""
    }
    
    static func studentsFromRequest(_ results: [[String:AnyObject]]) -> [Student] {
        
        var studentsArray = [Student]()
        
        for object in results {
            studentsArray.append(Student(dictionary: object)!)
        }
        return studentsArray
    }
    
}


