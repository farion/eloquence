//
//  EloChatManager.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 22.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import CoreData

class EloChatManager {
    
    static let sharedInstance = EloChatManager();
    
    var chats = [NSManagedObjectID:EloChat]();
    
    func connectAllAccounts(){
        let accounts = DataController.sharedInstance.getAccounts();
        NSLog("%@","connectall");
        
        
        NSLog("accountcount: %d",accounts.count);
        for account in accounts {
                    NSLog("%@",account.getJid()!);
            chats[account.objectID] = EloChat(account: account);
            if(account.isAutoConnect()){
                chats[account.objectID]!.connect();
            }
        }
    }
}