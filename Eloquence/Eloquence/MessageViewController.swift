import Cocoa
import JNWCollectionView

class MessageViewController: NSViewController, JNWCollectionViewDelegate, JNWCollectionViewDataSource, JNWCollectionViewListLayoutDelegate, EloChatDelegate {
    
    var chat:EloChat;
    dynamic var messages = [EloMessage]();

    @IBOutlet weak var mainInput: NSTextField!
    @IBOutlet weak var sendButton: NSButton!
    @IBOutlet var adressLabel: NSTextField!
    @IBOutlet var scrollView: JNWCollectionView!
    
    init(nibName nibNameOrNil:String?, chatId:EloChatId){
        chat = EloChats.sharedInstance.getChat(chatId.from, to: chatId.to);
        super.init(nibName: nibNameOrNil, bundle: nil)!;
        chat.delegate = self;
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adressLabel.stringValue = chat.to.jid + " via " + chat.from.jid;
        NSLog("Load message controller");
        view.autoresizingMask = [.ViewWidthSizable, .ViewHeightSizable]
        
        let listLayout = JNWCollectionViewListLayout(collectionView: scrollView)
        listLayout.rowHeight = 60
        listLayout.delegate = self
        
        scrollView .collectionViewLayout = listLayout
        
        scrollView.registerClass(EXMessageViewCellIncoming.self, forCellWithReuseIdentifier: "incomingCell")
        scrollView.registerClass(EXMessageViewCellOutgoing.self, forCellWithReuseIdentifier: "outgoingCell")
        
        scrollView.delegate = self
        scrollView.dataSource = self
        
        chat.loadInitialArchive();
        
        reloadAndScroll()
        
    }
    
    override func viewDidAppear() {
        scrollToBottom();
    }

    
    @IBAction func clickSendButton(sender: AnyObject) {

        let text = mainInput.stringValue;
 
        mainInput.stringValue = "";
        let msg = EloMessage();
        msg.text = "Ich: " + text;
        messages.append(msg);
        try! chat.sendTextMessage(text); //TODO
    }
    
    /** DELEGATE **/

    
    func didReceiveMessage(msg: EloMessage) {
        dispatch_async(dispatch_get_main_queue(), {
            self.messages.append(msg);
        })

    }
    
    func didFailSendMessage(msg: EloMessage){
        
    }
    
    private func scrollToBottom(){
        scrollView.scrollToItemAtIndexPath( NSIndexPath(forItem: chat.numberOfRows()-1, inSection: 0) , atScrollPosition: JNWCollectionViewScrollPosition.Top, animated: true)
    }
    
    private func reloadAndScroll() {
        scrollView.reloadData()
        scrollToBottom();
    }
    
    //Mark: EloChatDelegate
    func chatWillChangeContent() {
        
    }
    
    func chat(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    func chatDidChangeContent() {

        reloadAndScroll();
    }
    
    
    //Mark: JNWCollectionViewDelegate
    func collectionView(collectionView: JNWCollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        //TODO ?
    }
    
    //Mark: JNWCollectionViewDataSource
    func collectionView(collectionView: JNWCollectionView!, numberOfItemsInSection section: Int) -> UInt {
        return UInt(chat.numberOfRows());
    }
    
    
    //Mark: JNWCollectionViewListLayoutDelegate
   func collectionView(collectionView: JNWCollectionView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {

        let message = chat.getMessage(indexPath.item)

        let maximumLabelSize = CGSizeMake(scrollView.frame.size.width, CGFloat(FLT_MAX))
        let textRect = NSString(string:message.text!).boundingRectWithSize(maximumLabelSize, options: .UsesLineFragmentOrigin , attributes: [ NSFontAttributeName: NSFont.systemFontOfSize(13) ], context: nil)
    
        return textRect.height + 80
    }
    
    /// Asks the data source for the view that should be used for the cell at the specified index path. The returned
    func collectionView(collectionView: JNWCollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> JNWCollectionViewCell! {
        
        let message = chat.getMessage(indexPath.item)
        
        var cell:EXMessageViewCell
        
        if(message.isOutgoing){
            cell = scrollView.dequeueReusableCellWithIdentifier("outgoingCell") as! EXMessageViewCellOutgoing
        }else{
            cell = scrollView.dequeueReusableCellWithIdentifier("incomingCell") as! EXMessageViewCellIncoming
        }
        
        cell.setMessage(message);
        
        
        
        return cell;
    }
    
    
}
