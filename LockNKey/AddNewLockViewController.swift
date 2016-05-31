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
    
    var isAddController = false
    var isEditController = false
    
    var isCompanyValid = false
    var isUserValid = false
    var isPasswordValid = false
    
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        companyNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        urlTextField.delegate = self
        // Do any additional setup after loading the view.
        saveButton.enabled = isEditController
        if(isEditController){
            if(lockNKey != nil && !(lockNKey.companyName.isEmpty)){
                isCompanyValid = true
                isUserValid = true
                isPasswordValid = true
                companyNameTextField.text = lockNKey.companyName
                userNameTextField.text = lockNKey.userName
                passwordTextField.text = lockNKey.password
                urlTextField.text = lockNKey.url
            }
        }
        //cancelButton.addTarget(self, action: #selector(cancelView), forControlEvents: UIControlEvents.TouchUpInside)
        //saveButton.addTarget(self, action: #selector(backToViewWithLock), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button methods
    @IBAction func cancelView(sender: UIButton) {
        lockNKey = nil
        goBack()
    }
    
    func goBack()  {
        if(isAddController){
            goBackToMasterView()
        } else {
            goBackToDetailView()
        }
    }
    
    @IBAction func backToViewWithLock(sender: UIButton) {
        var url = ""
        if (!((self.urlTextField.text?.isEmpty)!)){
            url = self.urlTextField.text!
        }
        self.lockNKey = LockNKey(companyName: companyNameTextField.text!, userName: userNameTextField.text!, password: passwordTextField.text!, url: url)
        goBack()
    }
    
    func goBackToDetailView()  {
        self.performSegueWithIdentifier("unwindToDetailView", sender: self)
    }
    
    func goBackToMasterView()  {
        self.performSegueWithIdentifier("unwindToList", sender: self)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        enableSaveButton(textField)
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
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if(sender as! UIButton) != self.saveButton {
//            lockNKey = nil
//            return
//        }
//        
//        var url = ""
//        if (!((self.urlTextField.text?.isEmpty)!)){
//            url = self.urlTextField.text!
//        }
//        self.lockNKey = LockNKey(companyName: companyNameTextField.text!, userName: userNameTextField.text!, password: passwordTextField.text!, url: url)
//        
//        //        if(!(self.companyNameTextField.text?.isEmpty)!
//        //            && !(self.userNameTextField.text?.isEmpty)!
//        //            && !(self.passwordTextField.text?.isEmpty)!){
//        //            var url = ""
//        //            if (!((self.urlTextField.text?.isEmpty)!)){
//        //                url = self.urlTextField.text!
//        //            }
//        //            self.lockNKey.companyName = companyNameTextField.text!
//        //            self.lockNKey.userName = userNameTextField.text!
//        //            self.lockNKey.password = passwordTextField.text!
//        //            self.lockNKey.url = url
//        //        }
//        
//    }
    
    // MARK: Utilities
    func setAddController() {
        isAddController = true
        isEditController = false
    }
    
    func setEditController() {
        isAddController = false
        isEditController = true
    }
}