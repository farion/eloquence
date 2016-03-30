import Cocoa

class MainSplitViewController:NSSplitViewController, NSPageControllerDelegate, RosterViewControllerDelegate {
    
    @IBOutlet var sidebarItem: NSSplitViewItem!
    @IBOutlet var mainItem: NSSplitViewItem!
    
    var messageController = [EloChatId:MessageViewController]()
    var rosterViewController:RosterViewController?
    var messagePageController:NSPageController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        rosterViewController = RosterViewController(nibName:"RosterViewController",bundle:nil)
        rosterViewController!.delegate = self
        rosterItem = NSSplitViewItem(viewController: rosterViewController!)
        insertSplitViewItem(rosterItem!, atIndex: 0)
        
        messagePageController = NSPageController(
        messageItem = NSSplitViewItem(viewController:messagePageController!)
        insertSplitViewItem(messageItem!, atIndex: 1)*/
        rosterViewController = sidebarItem!.viewController as? RosterViewController
        rosterViewController!.delegate = self
        
        messagePageController = mainItem!.viewController as? NSPageController
        messagePageController!.delegate = self
        
    }
    
    private func getMessageController(chatId: EloChatId) -> MessageViewController{
        if(messageController[chatId] == nil){
            
            messageController[chatId] = MessageViewController(nibName:"MessageViewController", chatId:chatId)
        }
        return  messageController[chatId]!
    }
    
    func pageController(pageController: NSPageController, identifierForObject object: AnyObject) -> String {
        
        let chatId = object as! EloChatId
        return chatId.toString
        
    }
    
    func pageController(pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
        return getMessageController(EloChatId(identifier:identifier))
    }
    
    func didClickContact(chatId: EloChatId){
        NSLog("click" + chatId.to.jid );
        
        //TODO if I do not call it twice, the first clik nothing happens.
        messagePageController!.navigateForwardToObject(chatId)
        messagePageController!.navigateForwardToObject(chatId)
    }
}