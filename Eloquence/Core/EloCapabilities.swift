import Foundation
import XMPPFramework

class EloCapabilities {
    
    struct EloCapability {
        let xep:String
        let name:String
        let supportedByServer:Bool
    }
    
    func getCapabilities(jid: EloAccountJid) -> [EloCapability] {

        let xmppStream = EloConnections.sharedInstance.getConnection(jid).getXMPPStream();
        
        if(!xmppStream.isConnected()){
            return []
        }

        let query = XMPPCapabilitiesCoreDataStorage.sharedInstance().capabilitiesForJID(XMPPJID.jidWithUser(nil, domain: xmppStream.myJID.domain, resource: nil) , xmppStream: xmppStream)

        var serverCapabilities = [String]()
        
        for feature in query.elementsForName("feature") {
            let capability = feature.attributeStringValueForName("var")
            serverCapabilities.append(capability)
            NSLog("%@",capability)
        }
        
        return [

            EloCapability(
                xep: "0191",
                name: "Blocking Command 1.2+",
                supportedByServer: (["urn:xmpp:blocking"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0198",
                name: "Stream Management 1.3+",
                supportedByServer: (["urn:xmpp:sm:3"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0199",
                name: "XMPP Ping 2.0+",
                supportedByServer: (["urn:xmpp:ping"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0203",
                name: "Delayed Delivery 2.0+",
                supportedByServer: (["urn:xmpp:delay"].filter { serverCapabilities.contains($0) }.count > 0)
            ),            
            EloCapability(
                xep: "0237",
                name: "Roster Versioning 0.5+",
                supportedByServer: (["urn:xmpp:features:rosterver"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0280",
                name: "Message Carbons 0.7+",
                supportedByServer: (["urn:xmpp:carbons:2"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0313",
                name: "Message Archive Management 0.3+",
                supportedByServer: (["urn:xmpp:mam:0","urn:xmpp:mam:1"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0333",
                name: "Chat Markers 0.2.1",
                supportedByServer: (["urn:xmpp:chat-markers:0"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0352",
                name: "Client State Indication 0.2+",
                supportedByServer: (["urn:xmpp:csi:0"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0357",
                name: "Push Notifications 0.1+",
                supportedByServer: (["urn:xmpp:push:0"].filter { serverCapabilities.contains($0) }.count > 0)
            ),
            EloCapability(
                xep: "0363",
                name: "HTTP File Upload 0.2+",
                supportedByServer: (["urn:xmpp:http:upload"].filter { serverCapabilities.contains($0) }.count > 0)
            )
        ]        
    }
}

