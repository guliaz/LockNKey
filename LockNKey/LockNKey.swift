//
//  LockNKey.swift
//  LockNKey
//
//  Created by vikram on 4/10/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class LockNKey: NSObject, NSCoding {
    
    // MARK: Properties
    
    var companyName: String
    var userName: String
    var password: String
    var url: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("lockNKeys")
    
    // MARK: Types
    
    struct PropertyKey {
        static let companyKey = "company"
        static let usernameKey = "username"
        static let passwordKey = "password"
        static let urlKey = "url"
    }
    
    // MARK: Initialization
    
    init(companyName: String, userName: String, password: String, url: String = "") {
        // Initialize stored properties.
        self.companyName = companyName
        self.userName = userName
        self.password = password
        self.url = url
    }
        
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(companyName, forKey: PropertyKey.companyKey)
        aCoder.encodeObject(userName, forKey: PropertyKey.usernameKey)
        aCoder.encodeObject(password, forKey: PropertyKey.passwordKey)
        aCoder.encodeObject(url, forKey: PropertyKey.urlKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let companyName = aDecoder.decodeObjectForKey(PropertyKey.companyKey) as! String
        let userName = aDecoder.decodeObjectForKey(PropertyKey.usernameKey) as! String
        let password = aDecoder.decodeObjectForKey(PropertyKey.passwordKey) as! String
        let url = aDecoder.decodeObjectForKey(PropertyKey.urlKey) as! String
        
    
        // Must call designated initializer.
        self.init(companyName:companyName, userName: userName, password: password, url: url)
    }
    
    
}
