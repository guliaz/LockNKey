//
//  DetailViewController.swift
//  LockNKey
//
//  Created by vikram on 4/10/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK : Properties
    
    @IBOutlet weak var companyLabelValue: UILabel!
    @IBOutlet weak var usernameLabelValue: UILabel!
    @IBOutlet weak var passwordLabelValue: UILabel!
    @IBOutlet weak var urlLabelValue: UILabel!
    
    var lockNKey: LockNKey!
    var showPassword = false
    let maskedPassword = "************"
    
    var detailItem: Int? {
        didSet {
            // Update the view.
            // self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.lockNKey = LockNKeyStore.sharedInstance.getLockNKey(detail)
            updateDetails()
        }
        companyLabelValue.userInteractionEnabled = false
        usernameLabelValue.userInteractionEnabled = false
        passwordLabelValue.userInteractionEnabled = true
        urlLabelValue.userInteractionEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(valueChanged), name: "AddedItemInMaster", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        showPassword = false
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        if(touch?.view == passwordLabelValue && touch?.tapCount == 2){
            // show pin code view controller
            let uiTouches = (event?.allTouches())! as Set<UITouch>
            let uiLabel = uiTouches.first?.view as! UILabel
            let uiText = uiLabel.text
            if uiText != nil && uiText == maskedPassword{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("PinCodeView") as! PinCodeViewController
                vc.isAfterLoad = false
                self.presentViewController(vc, animated: true, completion: nil)
            } else{
                showPassword = false
                showPass()
            }
        }
    }
    
    // MARK: - Utils
    func updateDetails() {
        self.companyLabelValue.text = self.lockNKey.companyName
        self.usernameLabelValue.text = self.lockNKey.userName
        showPass()
        self.urlLabelValue.text = self.lockNKey.url
    }
    
    func showPass()  {
        if showPassword {
            self.passwordLabelValue.text = self.lockNKey.password
        } else {
            self.passwordLabelValue.text = maskedPassword
        }
    }
    
    @IBAction func showEditView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("AddEditLockView") as! AddNewLockViewController
        vc.setEditController()
        vc.lockNKey = self.lockNKey
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func unwindToDetailView(segue:UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! AddNewLockViewController
        let lockNKey = sourceController.lockNKey
        
        if lockNKey != nil {
            self.lockNKey = lockNKey
            updateDetails()
            LockNKeyStore.sharedInstance.removeLockNKey(self.detailItem!)
            LockNKeyStore.sharedInstance.replace(lockNKey, atIndex: self.detailItem!)
            LockNKeyStore.sharedInstance.saveLocks()
        }
    }
    
    @IBAction func unwindToDetailViewFromPin(segue:UIStoryboardSegue) {
        let sourceController = segue.sourceViewController as! PinCodeViewController
        let isValidPin = sourceController.isValidPin
        if(isValidPin){
            showPassword = true
        } else {
            showPassword = false
        }
        showPass()
    }
    
    func valueChanged(notification:NSNotification) {
        if let notificationLock = notification.object as? LockNKey{
            self.lockNKey = notificationLock
            updateDetails()
        }
    }
    
}

