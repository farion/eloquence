import Foundation
import XMPPFramework


@objc
protocol EloConnectionDelegate: NSObjectProtocol {
    
}

class EloConnection: NSObject, XMPPRosterDelegate,XMPPStreamDelegate, XMPPCapabilitiesDelegate, MulticastDelegateContainer {

    private let account:EloAccount
    private let xmppStream:XMPPStream
    private let xmppRoster:XMPPRoster
    private let xmppCapabilities:XMPPCapabilities
    private let xmppMessageArchiveManagement: XMPPMessageArchiveManagement
    //    let xmppvCardTempModule:XMPPvCardTempModule

    typealias DelegateType = EloConnectionDelegate;
    var multicastDelegate = [EloConnectionDelegate]()
    
    init(account:EloAccount){
        self.account = account
        xmppStream = XMPPStream();
        xmppRoster = XMPPRoster(rosterStorage: EloXMPPRosterCoreDataStorage.sharedInstance())
//        xmppvCardTempModule = XMPPvCardTempModule.init(withvCardStorage: XMPPvCardCoreDataStorage.sharedInstance())
//        xmppvCardTempModule!.activate(xmppStream)
        xmppRoster.autoFetchRoster = true;
        xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = true;

        xmppRoster.activate(xmppStream);

        xmppCapabilities = XMPPCapabilities(capabilitiesStorage: XMPPCapabilitiesCoreDataStorage.sharedInstance());
        //get server capabilities => XEP0030
        xmppCapabilities.autoFetchMyServerCapabilities = true;
        xmppCapabilities.activate(xmppStream)
        
        xmppMessageArchiveManagement = XMPPMessageArchiveManagement(messageArchiveManagementStorage: EloXMPPMessageArchiveManagementCoreDataStorage.sharedInstance())
        xmppMessageArchiveManagement.activate(xmppStream)
        
        super.init();
        
        xmppRoster.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppStream.addDelegate(self, delegateQueue:  dispatch_get_main_queue())
        xmppCapabilities.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        xmppMessageArchiveManagement.addDelegate(self, delegateQueue: dispatch_get_main_queue())

    }
    
    func isConnected() -> Bool {
        return xmppStream.isConnected();
    }
    
    func getXMPPStream() -> XMPPStream {
        return xmppStream;
    }
    
    func getArchive() -> XMPPMessageArchiveManagement {
        return xmppMessageArchiveManagement;
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
        
            xmppStream.myJID = XMPPJID.jidWithString(account.getJid().jid,resource:resource);
        
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
        
        NSNotificationCenter.defaultCenter().postNotificationName(EloConstants.CONNECTION_ONLINE, object: self);
//        xmppMessageArchiveManagement.mamQueryWith(sender.myJID , andStart: nil, andEnd: nil, andResultSet: nil)
        
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
    
    func xmppRosterDidEndPopulating(sender: XMPPRoster!) {
        NSLog("xmppRosterDidEndPopulating");
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterPush iq: XMPPIQ!) {
    }
    
    func xmppRoster(sender: XMPPRoster!, didReceiveRosterItem item: NSXMLElement!) {

    }

    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        NSLog("xmppRosterdidReceivePresenceSubscriptionRequest");
    }
    
    func xmppRosterDidBeginPopulating(sender: XMPPRoster!, withVersion version: String!) {
        NSLog("xmppRosterdidReceivePresenceSubscriptionRequest");
    }
    
    func xmppCapabilities(sender: XMPPCapabilities!, didDiscoverCapabilities caps: NSXMLElement!, forJID jid: XMPPJID!) {
        NSLog("xmppCapabilities %@",jid.bare());
    }
    
}