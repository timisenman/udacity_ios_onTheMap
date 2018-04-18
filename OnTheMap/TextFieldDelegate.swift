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

    func updateText(_ textField: UITextField){
        let vc = SetLocationViewController()
        if textField.text == vc.locationPlaceholderText || textField.text == vc.websitePlaceholderText {
            textField.text = ""
        } else {
            return
        }
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            updateText(textField)
        }
        
        //Hiding the Keyboard after a user hits Return
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}
