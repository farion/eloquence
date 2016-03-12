//
//  MessageViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 05.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework
import JSQMessagesViewController


class MessageViewController:JSQMessagesViewController, UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, EloChatDelegate {
    
    var chat: EloChat?;
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "";
        
        let size = self.collectionView!.frame.size;
            self.view!.frame = CGRectMake(0,0,200, 1000);
        
        /**
        *  You MUST set your senderId and display name
        */
        self.senderId = "Frieder";
        self.senderDisplayName = "Frieder";
        
 //       self.inputToolbar.contentView.textView.pasteDelegate = self;

        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadChat:", name: EloNotification.ACTIVATE_CONTACT, object: nil)
    }
    
    func loadChat(notification:NSNotification){
//        let user = notification.object as! XMPPUserCoreDataStorageObject
        
//        chat = EloConnectionManager.sharedInstance.getChat(user);
        
//        chat!.delegate = self;
        
        
    }
    
    
    func didReceiveChat(text: EloMessage) {
        
    }
    
    //Mark: JSQMessagesComposerTextViewPasteDelegate
    
    func composerTextView(textView: JSQMessagesComposerTextView!, shouldPasteWithSender sender: AnyObject!) -> Bool {
        return true;
    }
    
    
    //Mark JSQMessagesViewController
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        let message = JSQMessage(senderId: senderId, senderDisplayName:senderDisplayName, date: date, text: text)
        
        //put to date
        
        finishSendingMessageAnimated(true)
        
        
        
    }
}