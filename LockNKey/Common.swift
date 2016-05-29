//
//  Common.swift
//  LockNKey
//
//  Created by vikram on 4/30/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import Foundation

class Common {
    struct FieldPaceHolders {
        static let companyPlaceHolder = "Company Name"
        static let usernamePlaceHolder = "Enter Username"
        static let passwordPlaceHolder = "Enter Password"
        static let urlPlaceHolder = "Login Url"
    }
    
    static func enableSaveButton(isUserValid: Bool, isCompanyValid: Bool, isPasswordValid: Bool) -> Bool {
        // Disable the Save button if the text field is empty.
        if(isUserValid && isCompanyValid && isPasswordValid){
            return true
        } else {
            return false
        }
    }
    
}

