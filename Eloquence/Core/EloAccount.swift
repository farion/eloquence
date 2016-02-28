//
//  EloAccount.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 19.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import CoreData
import Foundation
import KeychainSwift


class EloAccount: NSManagedObject {
    
    @NSManaged var jid:NSString?;
    @NSManaged var resource: NSString?;
    @NSManaged var port: NSNumber?;
    @NSManaged var server: NSString?;
    @NSManaged var priority: NSNumber?;
    @NSManaged var autoconnect: NSNumber?;
    
    let keychainPasswordPrefix = "Eloquence password for ";
    
    func isAutoConnect() -> Bool {
        
        NSLog("isauto %@",autoconnect!);
        
        if(autoconnect == nil){
            return false;
        }
        return (autoconnect?.boolValue)!;
    }
    
    
    func getJid() -> String? {
        return jid as? String;
    }

    func getResource() -> String? {
        return resource as? String;
    }
    
    
    func getServer() -> String? {
        return server as? String
    }
    
    func getPort() -> Int? {
        return port as? Int;
    }
    
    func getPriority() -> Int? {
        return priority as? Int;
    }
    
    func getPassword() -> String? {
        
        let jid = getJid();
        
        if(jid == nil){
            return nil;
        }
        
        let safeJid = jid!;
        
        let keychain = KeychainSwift();
        return keychain.get(keychainPasswordPrefix + safeJid);
        
    }
    
    func setPassword(password: String) {
        
        let jid = getJid();
        
        if(jid == nil){
            return;
        }
        
        let safeJid = jid!;
        
        let keychain = KeychainSwift();
        keychain.set(password, forKey: keychainPasswordPrefix + safeJid);
        
        //directly get again, to trigger permission dialog
        keychain.get(keychainPasswordPrefix + safeJid);
    }
    
}