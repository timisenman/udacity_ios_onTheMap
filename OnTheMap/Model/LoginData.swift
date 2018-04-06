//
//  LoginData.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/5/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import Foundation

struct LoginData {
    let sessionID: String
    let success: Int
    
    init?(json: [String:Any]){
        self.sessionID = json["sessionID"] as? String ?? ""
        self.success = json["success"] as? Int ?? 0
    }
}
