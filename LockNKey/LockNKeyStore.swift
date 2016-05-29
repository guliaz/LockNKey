//
//  LockNKeyStore.swift
//  LockNKey
//
//  Created by vikram on 4/27/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import Foundation

class LockNKeyStore {
    
    var lockNKeys: [LockNKey] = []
    
    var pin: String = ""
    
    class var sharedInstance: LockNKeyStore {
        struct Static {
            static let instance = LockNKeyStore()
        }
        return Static.instance
    }
    
    init(){
        if let savedLocks = loadLocksNKeys(){
            lockNKeys += savedLocks
        } else {
            // Load the sample data.
            loadSampleData()
        }
        
        // load pin
        self.pin = loadPin()
    }
    
    // MARK: load sample data
    func loadSampleData() {
        // Load all lock and keys
        let lock1 = LockNKey(companyName: "dish", userName: "abc@def.com", password: "mypassword")
        let lock2 = LockNKey(companyName: "apple", userName: "apple@apple.com", password: "applePass", url: "www.apple.com")
        lockNKeys += [lock1, lock2]
    }
    
    var count:Int {
        return lockNKeys.count
    }
    
    func addLockNKey(lockNKey:LockNKey) {
        lockNKeys.append(lockNKey)
    }
    
    func replace(lockNKey: LockNKey, atIndex index: Int) {
        //lockNKeys[index] = lockNKey
        lockNKeys.insert(lockNKey, atIndex: index)
    }
    
    func removeLockNKey(index:Int) {
        lockNKeys.removeAtIndex(index)
    }
    
    func getLockNKey(index:Int) -> LockNKey {
        return lockNKeys[index]
    }
    
    func getLockNKeyIndex(lockNKey: LockNKey) -> Int {
        return lockNKeys.indexOf(lockNKey)!
    }
    
    // MARK: Base64
    
    func encodeToBase64(str:String) -> String {
        let utf8str = str.dataUsingEncoding(NSUTF8StringEncoding)
        if let base64Encoded = utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)){
            print("Encoded:  \(base64Encoded)")
            return base64Encoded
        }
        return ""
    }
    
    func decodeFromBase64(str:String) -> String {
        if let base64Decoded = NSData(base64EncodedString: str, options:   NSDataBase64DecodingOptions(rawValue: 0))
            .map({ NSString(data: $0, encoding: NSUTF8StringEncoding) }){
            // Convert back to a string
            print("Decoded:  \(base64Decoded)")
            return base64Decoded as! String
        }
        return ""
    }
    
    // MARK: PIN
    func setPin(pin:String) {
        self.pin = pin
        savePin()
    }
    
    func getPin()-> String {
        return self.pin
    }
    
    // MARK: NSCoding
    
    func saveLocks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lockNKeys, toFile: LockNKey.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save locks...")
        }
    }
    
    func savePin() {
        if(pin != "-1"){
            let pinString = encodeToBase64(pin)
            let isPinSaved = NSKeyedArchiver.archiveRootObject(pinString, toFile: LockNKey.PinArchiveFile.path!)
            if !isPinSaved {
                print("Failed to save pin...")
            }
        }
    }
    
    func loadPin() -> String {
        if let savedPin = NSKeyedUnarchiver.unarchiveObjectWithFile(LockNKey.PinArchiveFile.path!) as? String {
            let decodedPin = decodeFromBase64(savedPin)
            return decodedPin
        }
        return ""
    }
    
    func reload() {
        if let savedLocks = loadLocksNKeys(){
            lockNKeys = savedLocks
        }
    }
    
    func loadLocksNKeys() -> [LockNKey]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(LockNKey.ArchiveURL.path!) as? [LockNKey]
    }
    
    // MARK: Utilities
    
    func sort() {
        lockNKeys.sortInPlace(alphabetOrder)
    }
    
    
    // MARK: - Utilities
    
    func alphabetOrder(value1:LockNKey, value2:LockNKey)-> Bool {
        return value1.companyName < value2.companyName
    }
    
    
}