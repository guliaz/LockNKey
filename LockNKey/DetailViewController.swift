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
    
    var detailItem: LockNKey? {
        didSet {
            // Update the view.
            // self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            companyLabelValue.text = detail.companyName
            usernameLabelValue.text = detail.userName
            passwordLabelValue.text = detail.password
            urlLabelValue.text = detail.url
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

