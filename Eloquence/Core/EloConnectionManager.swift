//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Foundation
import CoreData

@objc
protocol EloConnectionManagerDelegate: NSObjectProtocol {
    
}


class EloConnectionManager: MulticastDelegateContainer {
    
    static let sharedInstance = EloConnectionManager();

    typealias DelegateType = EloConnectionManagerDelegate;
    var multicastDelegate = [EloConnectionManagerDelegate]()
    
    var connections = [String:EloConnection]();
    
    //TODO threadsafe

    func connectAllAccounts(){
        
        let accounts = DataController.sharedInstance.getAccounts();
        NSLog("%@","connectall");
        
        
        NSLog("accountcount: %d",accounts.count);
        for account in accounts {
                    NSLog("%@",account.getJid()!);
            connections[account.getJid()!] = EloConnection(account: account);
            if(account.isAutoConnect()){
                connections[account.getJid()!]!.connect();
            }
        }
    }
    
    func getChat(contact: EloContact) -> EloChat {
        let (_,connection) = connections.first!
        return EloChat(jid: contact.jid, connection: connection); //TODO
    }
    
    func getConnectionByJid(jid:String) -> EloConnection? {
        return connections[jid];
    }
    
    
}
// invokeDelegate { $0.method() }