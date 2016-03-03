//
//  EloContact.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 03.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa
import XMPPFramework

class EloContact:NSObject {
    
    var users = [XMPPUserCoreDataStorageObject]();
    
    var jid = "";
    var name = "";
    
    func addUser(user: XMPPUserCoreDataStorageObject){
        users.append(user);
        jid = user.jidStr;
        name = user.displayName;
    }
    
    func getJid() -> String {
        if(users.first != nil){
            return users.first!.jidStr;
        }
        return "UNKNOWN JID";
    }
}
