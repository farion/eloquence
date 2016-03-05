//
//  RosterViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 04.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit

class RosterCell:UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
}

class RosterViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var items: [String] = ["We", "Heart", "Swift"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell") as! RosterCell;
        cell.name.text = "FOO";
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        EloGlobalEvents.sharedInstance.activateContact(EloContact());
    }
    
}
