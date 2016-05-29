//
//  EditLockViewController.swift
//  LockNKey
//
//  Created by vikram on 4/30/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class EditLockViewController: UIViewController, UITextFieldDelegate {
    
    var lockNKey:LockNKey!
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var isCompanyValid = true
    var isUserValid = true
    var isPasswordValid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        urlTextField.delegate = self
        // Do any additional setup after loading the view.
        saveButton.enabled = true
        if(lockNKey != nil && !(lockNKey.companyName.isEmpty)){
            companyNameTextField.text = lockNKey.companyName
            userNameTextField.text = lockNKey.userName
            passwordTextField.text = lockNKey.password
            urlTextField.text = lockNKey.url
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        enableSaveButton(textField)
    }
    
    func enableSaveButton(textField: UITextField){
        if let fieldPlaceHolder = textField.attributedPlaceholder?.string {
            if(!(fieldPlaceHolder.isEmpty)){
                if(fieldPlaceHolder == Common.FieldPaceHolders.companyPlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isCompanyValid = true
                    } else  {
                        isCompanyValid = false
                    }
                } else if(fieldPlaceHolder == Common.FieldPaceHolders.usernamePlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isUserValid = true
                    } else  {
                        isUserValid = false
                    }
                } else if(fieldPlaceHolder == Common.FieldPaceHolders.passwordPlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isPasswordValid = true
                    } else  {
                        isPasswordValid = false
                    }
                }
            }
        }
        saveButton.enabled = Common.enableSaveButton(self.isUserValid, isCompanyValid: self.isCompanyValid, isPasswordValid: self.isPasswordValid )
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(sender as! UIBarButtonItem) != self.saveButton {
            lockNKey = nil
            return
        }
        
        if(!(self.companyNameTextField.text?.isEmpty)!
            && !(self.userNameTextField.text?.isEmpty)!
            && !(self.passwordTextField.text?.isEmpty)!){
            var url = ""
            if (!((self.urlTextField.text?.isEmpty)!)){
                url = self.urlTextField.text!
            }
            self.lockNKey.companyName = companyNameTextField.text!
            self.lockNKey.userName = userNameTextField.text!
            self.lockNKey.password = passwordTextField.text!
            self.lockNKey.url = url
        }
    }
    
}
