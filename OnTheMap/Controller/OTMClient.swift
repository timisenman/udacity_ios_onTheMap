//
//  Methods.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/22/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation
import UIKit

class OTMClient: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    
    func login(request: URLRequest, completionHandlerForLogin: @escaping (_ accountData: [String:AnyObject], _ sessionId: String, _ result: Int) -> Void) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                print(error!)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let json: [String:AnyObject]!
            do {
                json = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let accountData = json["account"] as? [String:AnyObject] else {
                print("No account data")
                return
            }
            
            
            guard let sessionData = json["session"] as? [String:AnyObject] else {
                print("Could not grab session data")
                return
            }
            
            guard let sessionId = sessionData["id"] as? String else {
                print("Could not access sessionID.")
                return
            }
            
            guard let isRegistered = accountData["registered"] as? Int else {
                print("Account not registered")
                return
            }
            
            completionHandlerForLogin(accountData, sessionId, isRegistered)
        }
        task.resume()
    }
    
    func taskForLoggedInStudentData(ofStudent: String, completionHandlerForLoggedIn: @escaping(_ firstName: String, _ lastName: String) -> Void) {
        let url = URL(string: Constants.UdacityConstants.GetLoggedInData + ofStudent)
        var request = URLRequest(url: url!)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderAccept)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let userData = results["user"] else {
                print("Cannot retrieve logged in user data.")
                return
            }
            
            if let firstName = userData["first_name"], let lastName = userData["last_name"] {
//                loggedInUser["firstName"] = firstName as? String
//                loggedInUser["lastName"] = lastName as? String
                completionHandlerForLoggedIn(firstName as! String, lastName as! String)
//                print("Logged in data after successful login: \(loggedInUser)")
            }
        }
        task.resume()
    }
    
    func taskForGet(request: URLRequest, completionHanlderForGet: @escaping(_ studentData: [Student]) -> Void) {

        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            }
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let studentDictionary = results["results"] as? [[String:AnyObject]] else {
                print("Not dictionary.")
                return
            }
            
            let students = Student.studentsFromRequest(studentDictionary)
            completionHanlderForGet(students)
        }
        task.resume()
    }
    
    func logoutAndDeleteSession(completionHandlerForDELETE: @escaping (_ sessionID: [String:AnyObject]) -> Void) {
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.UdacitySession)!)
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
            
            guard (error == nil) else {
                print("There was an error logging out.")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            var parsedData: [String:AnyObject]!
            do {
                parsedData = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let sessionData = parsedData["session"] as? [String:AnyObject] else {
                print("Could not parse session data from logout request.")
                return
            }
            
            completionHandlerForDELETE(sessionData)
        }
        task.resume()
    }
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
}
