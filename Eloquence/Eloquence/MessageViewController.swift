//
//  ChatViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 03.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa

class MessageViewController: NSViewController, EloGlobalEventActivateContactDelegate, EloChatDelegate {
    
    var contact: EloContact?;
    var chat:EloChat?;
    dynamic var messages = [EloMessage]();
    
    

    @IBOutlet weak var mainInput: NSTextField!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet weak var toJid: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Load message controller");
        EloGlobalEvents.sharedInstance.registerDelegate(self);
        
    }

    
    
    @IBAction func clickSendButton(sender: AnyObject) {

        let text = mainInput.stringValue;
        mainInput.stringValue = "";
        let msg = EloMessage();
        msg.text = "Ich: " + text;
        messages.append(msg);
        chat!.sendTextMessage(text);
    }
    
    /** DELEGATE **/
    func contactActivated(contact: EloContact) {
        self.contact = contact;
        chat = EloConnectionManager.sharedInstance.getChat(contact);
        toJid.stringValue = contact.jid;
        chat!.delegate = self;
    }
    
    func didReceiveChat(msg: EloMessage) {
        messages.append(msg);
    }
    
}
