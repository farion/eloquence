//
//  RosterViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 04.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework

class RosterViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, EloRosterDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var roster = EloRoster()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        roster.delegate = self
        roster.initializeData()

    }
    
    /* private */
    
    func configureCell(cell:RosterCell, atIndexPath: NSIndexPath){
        let user = roster.getUser(atIndexPath);
        cell.name.text = user.displayName
        cell.viaLabel.text = "via " + user.streamBareJidStr!
        cell.imageView!.image = user.photo;
    }
    
    /* UITableViewDataSource */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.numberOfRowsInSection(section);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell") as! RosterCell
        configureCell(cell,atIndexPath:indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSNotificationCenter.defaultCenter().postNotificationName(EloNotification.ACTIVATE_CONTACT, object: roster.getUser(indexPath));
    }
    
    /* NSFetchedResultsControllerDelegate */
    
    func rosterWillChangeContent() {
        tableView.beginUpdates()
    }
    
    func roster(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type){
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Delete:
                tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Update:
                configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! RosterCell ,atIndexPath: indexPath!)
                break
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
        }
    }
    
    func rosterDidChangeContent() {
        tableView.endUpdates()
    }
}
