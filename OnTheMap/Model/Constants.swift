//
//  Constants.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/22/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

//Parse Scheme: https://parse.udacity.com/parse/classes
//Parse Application ID: QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr
//REST API Key: QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY

//Udacity Scheme: https://www.udacity.com/api/session

//Facebook API ID "365362206864879"
//You will need to use the Facebook URL Scheme Suffix "onthemap"
struct Constants {
    
    struct UdacityConstants {
        
        static let UdacityHost = "udacity.com"
        static let UdacityAPIScheme = "https"
        static let UdacityAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let UdacityApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UdacityAppIDHeader = "X-Parse-Application-Id"
        static let UdacityAPIKeyHeader = "X-Parse-REST-API-Key"
        
    }
    
    struct UdacityParamKeys {
        static let test = "test"
    }
    
    struct ParseConstants {
        
        static let UdacityHost = "udacity.com"
        static let UdacityAPIScheme = "https"
        static let UdacityAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let UdacityApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UdacityAppIDHeader = "X-Parse-Application-Id"
        static let UdacityAPIKeyHeader = "X-Parse-REST-API-Key"
        
    }
    
    struct FacebookConstants {
        
        static let FacebookHost = "api.facebook.com"
        static let FacebookAppID = "365362206864879"
        
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
