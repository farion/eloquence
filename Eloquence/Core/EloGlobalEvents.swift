//
//  EloGlobalEvents.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 03.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation

protocol EloGlobalEventActivateContactDelegate: NSObjectProtocol {
    
    func contactActivated(contact: EloContact);
}

class EloGlobalEvents {
 
    static let sharedInstance = EloGlobalEvents();
    
    var activatedContactDelegates = [EloGlobalEventActivateContactDelegate]();
    
    func registerDelegate(delegate: EloGlobalEventActivateContactDelegate){
        activatedContactDelegates.append(delegate);
    }
    
    func unregisterDelegate(delegate: EloGlobalEventActivateContactDelegate) {
        guard let indexToRemove = activatedContactDelegates.indexOf({(item : EloGlobalEventActivateContactDelegate) -> Bool in
            return item === delegate
        }) else {return}
        
        activatedContactDelegates.removeAtIndex(indexToRemove)
    }
    
    func activateContact(contact: EloContact) {
        NSLog("event: %@",contact.jid);
        for delegate in activatedContactDelegates {
            delegate.contactActivated(contact);
        }
    }
    
    
}