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
    
    func loginWith(userName: String, password: String, completionHandlerForLogin: @escaping (_ success: Bool, _ error: String?) -> Void) {
        let url = URL(string: Constants.UdacityConstants.UdacitySession)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderAccept)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                completionHandlerForLogin(false, "Sorry: There was an error logging you in:\nError:\(error?.localizedDescription ?? "Unexpected error")")
                return
            }
            
            guard let data = data else {
                completionHandlerForLogin(false, "Sorry: There was no response during login.")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForLogin(false, "We couldn't log you in.\nCheck your name and password.")
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range)
            
            let json: [String:AnyObject]!
            do {
                json = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let accountData = json[Constants.LoginResponseKeys.account] as? [String:AnyObject] else {
                completionHandlerForLogin(false, "No account data during login.")
                return
            }
            
            guard let sessionData = json[Constants.LoginResponseKeys.session] as? [String:AnyObject] else {
                completionHandlerForLogin(false, "Could not grab session data during login.")
                return
            }
            
            guard let sessionId = sessionData[Constants.SessionResponseKeys.id] as? String else {
                completionHandlerForLogin(false, "Could not access sessionID.")
                return
            }
            
            UserArray.shared.loggedInUser["id"] = sessionId
            UserArray.shared.loggedInUser["uniqueKey"] = String(describing: accountData["key"]!)
            if let uniqueKey = UserArray.shared.loggedInUser["uniqueKey"] {
                self.taskForLoggedInStudentData(ofStudent: uniqueKey as! String) { (success, errorString, firstName, lastName) in
                    if success {
                        UserArray.shared.loggedInUser["firstName"] = firstName
                        UserArray.shared.loggedInUser["lastName"] = lastName
                    } else {
                        completionHandlerForLogin(false, "Your information wasn't accessible.")
                    }
                }
            }
            completionHandlerForLogin(true, nil)
        }
        task.resume()
    }
    
    func taskForLoggedInStudentData(ofStudent: String, completionHandlerForLoggedIn: @escaping(_ success: Bool, _ errorString: String?, _ firstName: String?, _ lastName: String?) -> Void) {
        let url = URL(string: Constants.UdacityConstants.GetLoggedInData + ofStudent)
        var request = URLRequest(url: url!)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderAccept)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)

        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completionHandlerForLoggedIn(false, "Sorry: There was an error downloading your data.\nError:\(error?.localizedDescription ?? "Unexpected error")", nil, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForLoggedIn(false, "Sorry: You couldn't connect to Udacity. Check your connection.", nil, nil)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range)
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let userData = results["user"] else {
                completionHandlerForLoggedIn(false, "Your information isn't available for Login.", nil, nil)
                return
            }
            
            if let firstName = userData["first_name"], let lastName = userData["last_name"] {
                completionHandlerForLoggedIn(true, nil, firstName as? String, lastName as? String)
            }
        }
        task.resume()
    }
    
    func taskForGetAllStudents(_ completionHanlderForGet: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.GetStudentData)!)
        request.httpMethod = "GET"
        request.addValue(Constants.UdacityConstants.UdacityApplicationID, forHTTPHeaderField: Constants.UdacityConstants.UdacityAppIDHeader)
        request.addValue(Constants.UdacityConstants.UdacityAPIKey, forHTTPHeaderField: Constants.UdacityConstants.UdacityAPIKeyHeader)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completionHanlderForGet(false, "Sorry: There was an error downloading Udacity's data.\nError:\(error?.localizedDescription ?? "Unexpected error")")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHanlderForGet(false, "Sorry: You couldn't connect to Udacity.")
                return
            }
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let studentDictionary = results["results"] as? [[String:AnyObject]] else {
                completionHanlderForGet(false, "It appears no student information is available.")
                return
            }
            
            StudentArray.shared.studentArray = Student.studentsFromRequest(studentDictionary)
            completionHanlderForGet(true, nil)
        }
        task.resume()
    }
    
    func logoutAndDeleteSession(completionHandlerForDELETE: @escaping (_ success: Bool, _ errorString: String?, _ sessionID: [String:AnyObject]?) -> Void) {
        
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
            guard (error == nil) else {
                completionHandlerForDELETE(false, "There was an error logging out: \(error!)", nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHandlerForDELETE(false,"Your logout request returned a status code other than 2xx!", nil)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) 
            
            var parsedData: [String:AnyObject]!
            do {
                parsedData = try? JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let sessionData = parsedData["session"] as? [String:AnyObject] else {
                completionHandlerForDELETE(false,"Could not parse session data from logout request.", nil)
                return
            }
            completionHandlerForDELETE(true, nil, sessionData)
        }
        task.resume()
    }
    
    func postStudentLocation(_ completionHanlderForPOST: @escaping(_ success: Bool, _ errorString: String?) -> Void) {
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.PostStudentData)!)
        request.httpMethod = "POST"
        request.addValue(Constants.UdacityConstants.UdacityApplicationID, forHTTPHeaderField: Constants.UdacityConstants.UdacityAppIDHeader)
        request.addValue(Constants.UdacityConstants.UdacityAPIKey, forHTTPHeaderField: Constants.UdacityConstants.UdacityAPIKeyHeader)
        request.addValue(Constants.UdacityConstants.HeaderJSON, forHTTPHeaderField: Constants.UdacityConstants.HeaderContent)
        request.httpBody = "{\"uniqueKey\": \"\(UserArray.shared.loggedInUser[Constants.LoggedInUser.uniqueKey]!)\", \"firstName\": \"\(UserArray.shared.loggedInUser[Constants.LoggedInUser.firstName]!)\", \"lastName\": \"\(UserArray.shared.loggedInUser[Constants.LoggedInUser.lastName]!)\",\"mapString\": \"\(UserArray.shared.loggedInUser[Constants.LoggedInUser.location]!)\", \"mediaURL\": \"\(UserArray.shared.loggedInUser[Constants.LoggedInUser.mediaURL]!)\",\"latitude\": \(UserArray.shared.loggedInUser[Constants.LoggedInUser.latitude]!), \"longitude\": \(UserArray.shared.loggedInUser[Constants.LoggedInUser.longitude]!)}".data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                completionHanlderForPOST(false, "There was an error posting your information.\nError:\(error?.localizedDescription ?? "Unexpected error")")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completionHanlderForPOST(false, "Sorry: You couldn't connect to Udacity to make the post.")
                return
            }
            
            var results: [String:AnyObject]!
            do {
                results = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
            }
            
            guard let objectId = results[Constants.LoggedInUser.objectId] as? String else {
                completionHanlderForPOST(false, "We cannot confirm your information was saved. Try again.")
                return
            }
            
            guard let createdAt = results[Constants.LoggedInUser.createdAt] as? String else {
                completionHanlderForPOST(false, "We cannot confirm your information was saved. Try again.")
                return
            }
            
            UserArray.shared.loggedInUser[Constants.LoggedInUser.objectId] = objectId
            UserArray.shared.loggedInUser[Constants.LoggedInUser.createdAt] = createdAt
            completionHanlderForPOST(true, nil)
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
