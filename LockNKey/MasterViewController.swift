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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // refresh stuff
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshTable), forControlEvents: UIControlEvents.ValueChanged)
        
        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(self.insertNewObject(_:)))
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        reloadTable()
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh
    func refreshTable(refreshControl: UIRefreshControl){
        reloadTable()
        refreshControl.endRefreshing()
    }
    
    func reloadTable()  {
        LockNKeyStore.sharedInstance.reload()
        self.tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = indexPath.row
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    @IBAction func unwindToList(segue:UIStoryboardSegue) {
        let sourceController:AddNewLockViewController = segue.sourceViewController as! AddNewLockViewController
        let lockNKey = sourceController.lockNKey
        
        if lockNKey != nil {
            LockNKeyStore.sharedInstance.addLockNKey(lockNKey)
            LockNKeyStore.sharedInstance.saveLocks()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "AddedItemInMaster", object: lockNKey))
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LockNKeyStore.sharedInstance.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LockKeyCell", forIndexPath: indexPath)
        LockNKeyStore.sharedInstance.sort()
        let lockNKey = LockNKeyStore.sharedInstance.getLockNKey(indexPath.row)
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
            LockNKeyStore.sharedInstance.removeLockNKey(indexPath.row)
            LockNKeyStore.sharedInstance.saveLocks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
}

