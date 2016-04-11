//
//  MasterViewController.swift
//  LockNKey
//
//  Created by vikram on 4/10/16.
//  Copyright © 2016 guliaz. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    var lockNKeys = [LockNKey]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Load all lock and keys
        if let savedLocks = loadLocksNKeys(){
            lockNKeys += savedLocks
        } else {
            // Load the sample data.
            loadSampleMeals()
        }

        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    // MARK: load sample data
    func loadSampleMeals() {
        let lock1 = LockNKey(companyName: "dish", userName: "abc@def.com", password: "mypassword")
        let lock2 = LockNKey(companyName: "apple", userName: "apple@apple.com", password: "applePass", url: "www.apple.com")
        
        lockNKeys += [lock1, lock2]
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let lockNKey = lockNKeys[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = lockNKey
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        
        let sourceController:AddNewLockViewController = segue.sourceViewController as! AddNewLockViewController
        let lockNKey = sourceController.lockNKey

        if lockNKey != nil {
            self.lockNKeys.append(lockNKey)
            self.saveLocks()
            self.tableView.reloadData()
        }
        
    }
    

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lockNKeys.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LockKeyCell", forIndexPath: indexPath)
        sort()
        let lockNKey = lockNKeys[indexPath.row] 
        cell.textLabel!.text = lockNKey.companyName
        cell.detailTextLabel!.text = lockNKey.userName
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            lockNKeys.removeAtIndex(indexPath.row)
            saveLocks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

     // MARK: NSCoding
    
    func saveLocks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(lockNKeys, toFile: LockNKey.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save locks...")
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

