import Foundation
import UIKit
import XMPPFramework
import JSQMessagesViewController


class MessageViewController:JSQMessagesViewController, UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, EloChatDelegate {
    
    @IBOutlet var splitView: NSSplitView!
    @IBOutlet var splitView: NSSplitView!
    @IBOutlet var splitView: NSSplitView!
    @IBOutlet var splitView: NSSplitView!
    private var chat: EloChat?;
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    @IBOutlet var scrollView: JNWCollectionView!
    @IBOutlet var splitView: NSSplitView!
    var messages = [JSQMessage]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "";
        setupBubbles()

        /**
        @IBOutlet var adressLabel: NSTextField!
        @IBOutlet var adressLabel: NSTextField!
        *  You MUST set your senderId and display name
        */
        self.senderId = "Frieder";
        self.senderDisplayName = "Frieder";
        
 //       self.inputToolbar.contentView.textView.pasteDelegate = self;

        self.view!.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadChat:", name: EloConstants.ACTIVATE_CONTACT, object: nil)
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,  messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
            return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = messages[indexPath.item] // 1
            if message.senderId == senderId { // 2
                return outgoingBubbleImageView
            } else { // 3
                return incomingBubbleImageView
            }
    }
    
    private func getSafeChat() -> EloChat {
        return chat!
    }
    
    
    func loadChat(notification:NSNotification){
        let chatId = notification.object as! EloChatId
        
        chat = EloChats.sharedInstance.getChat(chatId.from, to: chatId.to);
        chat!.delegate = self;
        title = chatId.from.jid;
    }
    
    //Mark: EloChatDelegate
    
    func didReceiveMessage(msg: EloMessage) {
        dispatch_async(dispatch_get_main_queue(), {
            let message = JSQMessage(senderId: msg.author , senderDisplayName:msg.author, date: NSDate(), text: msg.text )
            self.messages.append(message)
            self.finishReceivingMessageAnimated(true)
        })

    }
    
    func didFailSendMessage(msg: EloMessage) {
        
    }
    
    
    //Mark: JSQMessagesComposerTextViewPasteDelegate
    
    func composerTextView(textView: JSQMessagesComposerTextView!, shouldPasteWithSender sender: AnyObject!) -> Bool {
        return true;
    }
    
    
    //Mark JSQMessagesViewController
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound();
        
        let message = JSQMessage(senderId: senderId, senderDisplayName:senderDisplayName, date: date, text: text)
        messages.append(message)
        
        do {
            try getSafeChat().sendTextMessage(text);
        }catch EloChatError.NotConnected {
            //TODO
        }catch {
            //TODO
        }
        
        finishSendingMessageAnimated(true)
        
        
        
    }
}