//
//  RosterController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 29.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import XMPPFramework



class RosterViewController: NSViewController, NSTableViewDelegate {

    @IBOutlet weak var rosterTable: NSTableView!

    dynamic var contacts = [EloContact]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        rosterTable.setDelegate(self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshData", name: EloNotification.ROSTER_CHANGED, object: nil);
        
        refreshData();

    }

    override func awakeFromNib() {
        rosterTable.doubleAction = "cellDblClk:";
    }
    
    func cellDblClk(sender: AnyObject){
        if(rosterTable.clickedRow >= 0){
            NSLog("Jid clicked: %@",contacts[rosterTable.clickedRow].jid)
            EloGlobalEvents.sharedInstance.activateContact(contacts[rosterTable.clickedRow]);
        }
    }
    
    @IBAction func reloadClick(sender: AnyObject) {
        refreshData();
    }
    
    func refreshData(){
        
        let fetchRequest = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject");
    
        var contactDic = [String:EloContact]()
        do {
            for (_,connection) in EloConnectionManager.sharedInstance.connections {
                
                let users = try connection.xmppRosterStorage.mainThreadManagedObjectContext.executeFetchRequest(fetchRequest) as! [XMPPUserCoreDataStorageObject];
                for user  in users {
                    if(contactDic[user.jidStr] == nil){
                        contactDic[user.jidStr] = EloContact();
                    }
                    contactDic[user.jidStr]!.addUser(user);
                }
            }
        } catch {
            Swift.print(error)
        }
        
        contacts = [EloContact]();
        for (_, contact) in contactDic {
            contacts.append(contact);
            NSLog("Roster: %@",contact.getJid());
        }
        
    }
    func cellClick(sender:AnyObject){
        
    }
}