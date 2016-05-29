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
    
    @IBOutlet weak var pinCodeTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cancelButton.layer.borderColor = UIColor.whiteColor().CGColor
        cancelButton.addTarget(self, action: #selector(cancelView), forControlEvents: UIControlEvents.TouchUpInside)
        isValidPin = false
        pinCodeTextField.delegate = self
        pinCodeTextField.becomeFirstResponder()
        
    }
    
    // MARK: Button method
    func cancelView(sender:UIButton) {
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if(textField.text! != "" && textField.text!.characters.count==4){
            textField.resignFirstResponder()
        }
        validatePin(textField.text!, textField: textField)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField.text! != "" && textField.text!.characters.count==4){
            textField.resignFirstResponder()
        }
        validatePin(textField.text!, textField: textField)
    }
    
    // MARK : Logic methods
    
    
    func goBackToDetailView()  {
        self.performSegueWithIdentifier("unwindToDetailViewFromPin", sender: self)
    }
    
    func validatePin(pinText:String, textField: UITextField){
        if(pinText != "" && pinText.characters.count==4 && pinText == LockNKeyStore.sharedInstance.getPin()){
            textField.resignFirstResponder()
            self.isValidPin = true
            goBackToDetailView()
        }
    }
}