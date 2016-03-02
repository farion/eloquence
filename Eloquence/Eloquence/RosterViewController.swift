//
//  RosterController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 29.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import XMPPFramework

class RosterViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var rosterTable: NSTableView!

    var data = [XMPPUserCoreDataStorageObject]();
    
    var delegate: RosterViewControllerDelegate? = nil;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshData();
        rosterTable.setDelegate(self)
        rosterTable.setDataSource(self)

    }

    override func awakeFromNib() {
        rosterTable.doubleAction = "cellDblClk:";
    }
    
    func cellDblClk(sender: AnyObject){
        if(rosterTable.clickedRow >= 0){
            if(delegate != nil){
                delegate!.contactActivated(data[rosterTable.clickedRow].jidStr);
            }
        }
    }
    
    @IBAction func reloadClick(sender: AnyObject) {
        refreshData();
    }
    
    func refreshData(){
        let fetchRequest = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject");
        
        
        data = [XMPPUserCoreDataStorageObject]();
        do {
            for (_,chat) in EloChatManager.sharedInstance.chats {
                let users = try chat.xmppRosterStorage.mainThreadManagedObjectContext.executeFetchRequest(fetchRequest) as! [XMPPUserCoreDataStorageObject];
                data.appendContentsOf(users);
            }
        } catch {
            Swift.print(error)
        }
        rosterTable.reloadData();
    }
    
    /** NSTableViewDataSource, NSTableViewDelegate */
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        NSLog("COUNT: %d",data.count);
        // how many rows are needed to display the data?
        return data.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // get an NSTableCellView with an identifier that is the same as the identifier for the column
        // NOTE: you need to set the identifier of both the Column and the Table Cell View
        // in this case the columns are "name" and "value"
        let result = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        
        // get the "Item" for the row
        let item = data[row]
        
        // get the value for this column
        if let val = item.displayName {
            result.textField?.stringValue = val
        } else {
            // if the attribute's value is missing enter a blank string
            result.textField?.stringValue = "NIX"
        }
        
        return result
    }
}