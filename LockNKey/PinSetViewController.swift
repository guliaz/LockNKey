//
//  PinSetViewController.swift
//  LockNKey
//
//  Created by vikram on 5/29/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class PinSetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var pinTextField1: UITextField!
    @IBOutlet weak var pinTextField2: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var pin1: String = ""
    var pin2: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        doneButton.addTarget(self, action: #selector(validatePins), forControlEvents: UIControlEvents.TouchUpInside)
        pinTextField1.delegate = self
        pinTextField2.delegate = self
        pinTextField1.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 4
    }
    
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {
    //        if(textField.text! != "" && textField.text!.characters.count == 4){
    //            if(textField == pinTextField1){
    //                pin1 = textField.text!
    //            }
    //            if(textField == pinTextField2){
    //                pin2 = textField.text!
    //            }
    //        }
    //        // Hide the keyboard.
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        if(textField.text! != "" && textField.text!.characters.count == 4){
    //            if(textField == pinTextField1){
    //                pin1 = textField.text!
    //            }
    //            if(textField == pinTextField2){
    //                pin2 = textField.text!
    //            }
    //        }
    //    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text! != "" && textField.text!.characters.count == 4){
            if(textField == pinTextField1){
                pin1 = textField.text!
            }
            if(textField == pinTextField2){
                pin2 = textField.text!
            }
        }
    }
    
    // MARK : Logic methods
    func goToSplitView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MasterController") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func validatePins(){
        pinTextField1.resignFirstResponder()
        pinTextField2.resignFirstResponder()
        if(pin1.characters.count == 4 && pin2.characters.count == 4 && pin1 == pin2){
            LockNKeyStore.sharedInstance.setPin(pin1)
            LockNKeyStore.sharedInstance.savePin()
            goToSplitView()
        } else {
            mainLabel.text? = "Pins dont match, try again"
            mainLabel.textColor = UIColor.redColor()
            pinTextField1.text? = ""
            pinTextField2.text? = ""
            pinTextField1.becomeFirstResponder()
        }
    }
}
