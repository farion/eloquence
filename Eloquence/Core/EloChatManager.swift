//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Foundation
import CoreData

class EloChatManager: MulticastDelegateContainer {
    
    static let sharedInstance = EloChatManager();

    typealias DelegateType = EloChatManagerDelegate;
    var multicastDelegate = [EloChatManagerDelegate]()
    
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
// invokeDelegate { $0.method() }