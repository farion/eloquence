//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Foundation
import XMPPFramework

class EloChat: NSObject, XMPPRosterDelegate,XMPPStreamDelegate, MulticastDelegateContainer {
    
    var xmppStream = XMPPStream();
    var account:EloAccount;
    var xmppRosterStorage = XMPPRosterCoreDataStorage()
    var xmppRoster: XMPPRoster?;

    typealias DelegateType = EloChatDelegate;
    var multicastDelegate = [EloChatDelegate]()
    
    init(account:EloAccount){
        self.account = account;
        super.init();
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage);
        xmppRoster!.autoFetchRoster = true;
        xmppRoster!.autoAcceptKnownPresenceSubscriptionRequests = true;
        xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue());
        xmppRoster!.activate(xmppStream);
    }
    
    
    func connect(){
        
        NSLog("Connect");
        
        if(!xmppStream.isConnected()){
//        var presence = XMPPPresence();
//        let priority = DDXMLElement.elementWithName("priority", stringValue: "1") as! DDXMLElement;
        
            var resource = account.getResource();
            if(resource == nil || resource!.isEmpty){
                resource = "Eloquence";
            }
        
            xmppStream.myJID = XMPPJID.jidWithString(account.getJid(),resource:resource);
        
            let port = account.getPort();
            if(port != nil && port > 0){
                xmppStream.hostPort = UInt16.init(port!);
            }
        
            let domain = account.getServer();
            if(domain != nil && domain!.isEmpty){
                xmppStream.hostName = domain;
            }
        
            do {
                try xmppStream.connectWithTimeout(XMPPStreamTimeoutNone);
            }catch {
                NSLog("error");
                print(error);
            }
        }
        

    }
    
	//MARK: XMPP Delegates
	func xmppStreamDidConnect(sender: XMPPStream!) {
        NSLog("Did Connect");
        do {
         try xmppStream.authenticateWithPassword(account.getPassword());
        }catch {
            NSLog("error");
            print(error);
        }
    }
    
    func xmppStreamWillConnect(sender:XMPPStream) {
        NSLog("Will Connect");
    }
    
    func xmppStream(sender: XMPPStream!, alternativeResourceForConflictingResource conflictingResource: String!) -> String! {
        NSLog("alternativeResourceForConflictingResource");
        return conflictingResource;
    }
    
    func xmppStream(sender: XMPPStream!, didFailToSendIQ iq: XMPPIQ!, error: NSError!) {
        NSLog("didFailToSendIQ");
    }
    
    func xmppStream(sender: XMPPStream!, didFailToSendMessage message: XMPPMessage!, error: NSError!) {
        NSLog("didFailToSendMessage");
    }
    
    func xmppStream(sender: XMPPStream!, didFailToSendPresence presence: XMPPPresence!, error: NSError!) {
        NSLog("didFailToSendPresence");
    }
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: NSXMLElement!) {
        NSLog("didNotAuthenticate");
    }
    func xmppStream(sender: XMPPStream!, didNotRegister error: NSXMLElement!) {
        NSLog("didNotRegister");
    }
    func xmppStream(sender: XMPPStream!, didReceiveCustomElement element: NSXMLElement!) {
        NSLog("didReceiveCustomElement");
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveError error: NSXMLElement!) {
        NSLog("didReceiveError");
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveIQ iq: XMPPIQ!) -> Bool {
        NSLog("didReceiveIQ");
        /*
        let queryElement = iq.elementForName("query",xmlns:"jabber:iq:roster");
        
        if(queryElement != nil){
            let itemElements = queryElement!.elementsForName("item");
            for var i = 0; i < itemElements.count; ++i {
                let jid = itemElements[i].attributeForName("jid")!.stringValue;
                NSLog("%@",jid!);
            }
        }
        
        */
        return true;
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        NSLog("didReceiveMessage");
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveP2PFeatures streamFeatures: NSXMLElement!) {
        NSLog("didReceiveP2PFeatures");
    }
    
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        NSLog("didReceivePresence");
    }
    
    func xmppStream(sender: XMPPStream!, didReceiveTrust trust: SecTrust!, completionHandler: ((Bool) -> Void)!) {
        NSLog("didReceiveTrust");
    }
    
    func xmppStream(sender: XMPPStream!, didRegisterModule module: AnyObject!) {
                NSLog("didRegisterModule");
    }
    
    func xmppStream(sender: XMPPStream!, didSendCustomElement element: NSXMLElement!) {
        NSLog("didSendCustomElement");
    }
    
    func xmppStream(sender: XMPPStream!, didSendIQ iq: XMPPIQ!) {
        NSLog("didSendIQ");
    }
    
    func xmppStream(sender: XMPPStream!, didSendMessage message: XMPPMessage!) {
        NSLog("didSendMessage");
    }
    
    func xmppStream(sender: XMPPStream!, didSendPresence presence: XMPPPresence!) {
        NSLog("didSendPresence");
    }
    
    func xmppStream(sender: XMPPStream!, willReceiveIQ iq: XMPPIQ!) -> XMPPIQ! {
        NSLog("willReceiveIQ");
        return iq;
    
    }
    
    func xmppStream(sender: XMPPStream!, willReceiveMessage message: XMPPMessage!) -> XMPPMessage! {
        NSLog("willReceiveMessage");
        return message;
    }
    
    func xmppStream(sender: XMPPStream!, willReceivePresence presence: XMPPPresence!) -> XMPPPresence! {
        NSLog("willReceivePresence");
        return presence;
    }
    
    func xmppStream(sender: XMPPStream!, willSecureWithSettings settings: NSMutableDictionary!) {
                NSLog("willSecureWithSettings");
    }
    
    func xmppStream(sender: XMPPStream!, willSendIQ iq: XMPPIQ!) -> XMPPIQ! {
        NSLog("willSendIQ");
        return iq;
    }
    
    func xmppStream(sender: XMPPStream!, willSendMessage message: XMPPMessage!) -> XMPPMessage! {
        NSLog("willSendMessage");
        return message;
    }
    
    func xmppStream(sender: XMPPStream!, willSendP2PFeatures streamFeatures: NSXMLElement!) {
        NSLog("willSendP2PFeatures");
    }
    
    func xmppStream(sender: XMPPStream!, willSendPresence presence: XMPPPresence!) -> XMPPPresence! {
                NSLog("willSendPresence");
        return presence;
    }
    
    func xmppStream(sender: XMPPStream!, willUnregisterModule module: AnyObject!) {
             NSLog("willUnregisterModule");
    }
    
    func xmppStreamConnectDidTimeout(sender: XMPPStream!) {
        NSLog("xmppStreamConnectDidTimeout");
    }
    
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        NSLog("xmppStreamDidAuthenticate");
        
        
        if (xmppRoster != nil) {
            xmppRoster = nil;
        }
        
        xmppRoster = XMPPRoster.init(rosterStorage: xmppRosterStorage);
        
        if(xmppRoster == nil){
            //TODO error
        }
        
        xmppRoster!.addDelegate(self, delegateQueue: dispatch_get_main_queue());
        xmppRoster!.autoFetchRoster = true;
        
        
    }
    
    func xmppStreamDidChangeMyJID(xmppStream: XMPPStream!) {
        NSLog("xmppStreamDidChangeMyJID");
    }
    
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        NSLog("xmppStreamDidDisconnect");
    }
    
    func xmppStreamDidFilterStanza(sender: XMPPStream!) {
        NSLog("xmppStreamDidFilterStanza");
    }
    
    func xmppStreamDidRegister(sender: XMPPStream!) {
        NSLog("xmppStreamDidRegister");
    }
    
    func xmppStreamDidSecure(sender: XMPPStream!) {
        NSLog("xmppStreamDidSecure");
    }
    
    func xmppStreamDidSendClosingStreamStanza(sender: XMPPStream!) {
        NSLog("xmppStreamDidSendClosingStreamStanza");
    }
    
    func xmppStreamDidStartNegotiation(sender: XMPPStream!) {
        NSLog("xmppStreamDidStartNegotiation");
    }
    
    func xmppStreamWasToldToDisconnect(sender: XMPPStream!) {
        NSLog("xmppStreamWasToldToDisconnect");
    }
    
    
}
