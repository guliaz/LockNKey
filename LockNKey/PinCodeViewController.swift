//
//  PinCodeViewController.swift
//  LockNKey
//
//  Created by vikram on 5/25/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class PinCodeViewController: UIViewController, UITextFieldDelegate {
    
    // MARK : Properties
    var isValidPin:Bool = false
    
    var isAfterLoad = false;
    var pin = ""
    
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.layer.borderColor = UIColor.whiteColor().CGColor
        if(isAfterLoad){
            cancelButton.enabled = false
        } else {
            cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
            cancelButton.addTarget(self, action: #selector(cancelView), forControlEvents: UIControlEvents.TouchUpInside)
        }
        doneButton.addTarget(self, action: #selector(validatePin), forControlEvents: UIControlEvents.TouchUpInside)
        isValidPin = false
        pinCodeTextField.delegate = self
        pinCodeTextField.becomeFirstResponder()
    }
    
    // MARK: Button method
    func cancelView(sender:UIButton) {
        pinCodeTextField.resignFirstResponder()
        goBackToDetailView()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //        if(textField.text! != "" && textField.text!.characters.count==4){
    //            textField.resignFirstResponder()
    //        }
    //        validatePin(textField.text!, textField: textField)
    //    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text! != "" && textField.text!.characters.count == 4){
            if(textField == pinCodeTextField){
                pin = textField.text!
            }
        }
    }
    
    // MARK : Logic methods
    func goBackToDetailView()  {
        self.performSegueWithIdentifier("unwindToDetailViewFromPin", sender: self)
    }
    
    func goToSplitView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // MasterController | SplitViewController
        let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MasterController") as! UINavigationController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func validatePin(){
        pinCodeTextField.resignFirstResponder()
        if(pin != "" && pin.characters.count==4 && pin == LockNKeyStore.sharedInstance.getPin()){
            self.isValidPin = true
            if(isAfterLoad){
                goToSplitView()
            } else {
                goBackToDetailView()
            }
        } else {
            self.isValidPin = false
        }
    }
}