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
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        downloadUserData()
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        OTMClient.sharedInstance().logoutAndDeleteSession { (success, errorString, sessionData) in
            logoutData = sessionData!
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshDataAction(_ sender: Any) {
        downloadUserData()
    }
    
    func downloadUserData() {
        OTMClient.sharedInstance().taskForGet() { (success, errorString) in
            if success {
                performUIUpdatesOnMain {
                    self.tableView.reloadData()
                }
            } else {
                self.displayError(withString: errorString!)
            }
        }
    }
    
    func displayError(withString: String) {
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: "Oops!", message: withString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = "studentsCells"
        let student = studentArray![(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomCellViewControllerTableViewCell
        
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        cell.studentSite.text = student.mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray!.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellReuseIdentifier = "studentsCells"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomCellViewControllerTableViewCell
        let student = studentArray![(indexPath as NSIndexPath).row]
        let app = UIApplication.shared
        if let toOpen = cell.studentSite?.text {
            if toOpen.contains("https://") {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    if success {
                        print("URL opened successfully")
                    } else {
                        self.displayError(withString: "This isn't a valid URL.")
                    }
                }
            } else {
                self.displayError(withString: "This isn't a valid URL.")
            }
        }
    }
}


