//
//  EloChat.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 02.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import XMPPFramework

protocol EloChatDelegate {
    func didReceiveChat(text: EloMessage);
}

class EloChat: XMPPStreamDelegate {
    
    var possibleConnections = [EloConnection]();
    
    var currentConnection: EloConnection?;
    
    var delegate: EloChatDelegate?;
    
    let jid: String;
    
    init(jid: String, connection: EloConnection){
        currentConnection = connection;
        self.jid = jid;
        connection.xmppStream.addDelegate(self, delegateQueue:  dispatch_get_main_queue());
    }
    
    func sendTextMessage(text: String){
        NSLog("Send Message: %@",text);
        
        let msg = XMPPMessage(type: "chat", to: XMPPJID.jidWithString(jid) );
        msg.addBody(text);
        currentConnection?.xmppStream.sendElement(msg);

    }
    
    @objc func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {

        
        NSLog("VON: %@ == %@", message.from().bare(),jid);
        if(message.from().bare() == jid){
            if(delegate != nil){
                let msg = EloMessage();
                msg.text = jid + ": " + message.body();
                delegate?.didReceiveChat(msg);
            }
        }else{
            NSLog("nix für mich");
        }
    }
    
}