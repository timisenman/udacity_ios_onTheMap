//
//  Constants.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/22/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

struct Constants {
    
    struct UdacityConstants {
        
        static let UdacitySession = "https://www.udacity.com/api/session"
        static let UdacityAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let UdacityApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UdacityAppIDHeader = "X-Parse-Application-Id"
        static let UdacityAPIKeyHeader = "X-Parse-REST-API-Key"
        static let SignUpFormURL = "https://www.udacity.com/account/auth#!/signup"
        static let HeaderJSON = "application/json"
        static let HeaderAccept = "Accept"
        static let HeaderContent = "Content-Type"
        static let GetStudentData = "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt" 
        static let PostStudentData =  "https://parse.udacity.com/parse/classes/StudentLocation"
        static let GetLoggedInData = "https://www.udacity.com/api/users/"
    }
    
    struct LoginResponseKeys {
        static let account = "account"
        static let session = "session"
    }
    
    struct SessionResponseKeys {
        static let id = "id"
        static let expiration = "expiration"
    }
    
    struct AccountResponseKeys {
        static let key = "key"
        static let registered = "registered"
    }
    
    struct StudentResponseKeys {
        static let objectKey = "objectId"
        static let uniqueKeyKey = "uniqueKey"
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let mapStringKey = "mapString"
        static let mediaURLKey = "mediaURL"
        static let latitudeKey = "latitude"
        static let longitudeKey = "longitude"
        static let createAtKey = "createdAt"
        static let updatedAtKey = "updatedAt"  
    }
    
    struct Segues {
        static let confirmLocation = "ConfirmLocationSegue"
    }
}
