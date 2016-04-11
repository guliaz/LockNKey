//
//  AddNewLockViewController.swift
//  LockNKey
//
//  Created by vikram on 4/10/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class AddNewLockViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    var lockNKey:LockNKey!
    
    var isCompanyValid = false
    var isUserValid = false
    var isPasswordValid = false
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    struct FieldPaceHolders {
        static let companyPlaceHolder = "Company Name"
        static let usernamePlaceHolder = "Enter Username"
        static let passwordPlaceHolder = "Enter Password"
        static let urlPlaceHolder = "Login Url"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        urlTextField.delegate = self
        // Do any additional setup after loading the view.
        saveButton.enabled = false
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
        if let fieldPlaceHolder = textField.attributedPlaceholder?.string {
            if(!(fieldPlaceHolder.isEmpty)){
                if(fieldPlaceHolder == FieldPaceHolders.companyPlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isCompanyValid = true
                    }
                } else if(fieldPlaceHolder == FieldPaceHolders.usernamePlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isUserValid = true
                    }
                } else if(fieldPlaceHolder == FieldPaceHolders.passwordPlaceHolder){
                    if(!((textField.text?.isEmpty)!)){
                        isPasswordValid = true
                    }
                }
            }
        }
        enableSaveButton()
    }
    
    func enableSaveButton() {
        // Disable the Save button if the text field is empty.
        if(isUserValid && isCompanyValid && isPasswordValid){
            saveButton.enabled = true
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(sender as! UIBarButtonItem) != self.saveButton {
            return
        }
        
        if(!(self.companyNameTextField.text?.isEmpty)!
            && !(self.userNameTextField.text?.isEmpty)!
            && !(self.passwordTextField.text?.isEmpty)!){
            var url = ""
            if (!((self.urlTextField.text?.isEmpty)!)){
                url = self.urlTextField.text!
            }
            self.lockNKey = LockNKey(companyName: companyNameTextField.text!, userName: userNameTextField.text!, password: passwordTextField.text!, url: url)
        }
    }
    
    
}
