//
//  ViewController.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 3/22/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class CellTableViewController: UITableViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var addLocationButton: UIBarButtonItem!
    
    var students: [Student] = [Student]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        downloadUserData()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.sharedInstance().logoutAndDeleteSession { (sessionData) in
            logoutData = sessionData
            print("\nLogging Out with: \(logoutData)\n")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func downloadUserData() {
        var request = URLRequest(url: URL(string: Constants.UdacityConstants.GetStudentData)!)
        request.httpMethod = "GET"
        request.addValue(Constants.UdacityConstants.UdacityApplicationID, forHTTPHeaderField: Constants.UdacityConstants.UdacityAppIDHeader)
        request.addValue(Constants.UdacityConstants.UdacityAPIKey, forHTTPHeaderField: Constants.UdacityConstants.UdacityAPIKeyHeader)
        
        OTMClient.sharedInstance().taskForGet(request: request) { (studentData) in
            self.students = studentData
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "studentsCells"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomCellViewControllerTableViewCell
        
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        cell.studentSite.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        UIApplication.shared.open(URL(string: "\(student.mediaURL)")!, options: [:]) { (success) in
            if success {
                print("URL opened successfully")
            } else {
                print("URL not opened.")
            }
        }
    }
}


