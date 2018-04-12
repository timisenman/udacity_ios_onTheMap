//
//  TextFieldDelegates.swift
//  OnTheMap
//
//  Created by Timothy Isenman on 4/12/18.
//  Copyright © 2018 Timothy Isenman. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    //Hiding the Keyboard after a user hits Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
