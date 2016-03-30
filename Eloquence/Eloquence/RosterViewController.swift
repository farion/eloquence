import Foundation
import XMPPFramework
import JNWCollectionView

protocol RosterViewControllerDelegate {
    func didClickContact(chatId:EloChatId);
}

class RosterViewController: NSViewController , EloRosterDelegate, JNWCollectionViewDataSource, JNWCollectionViewDelegate, JNWCollectionViewListLayoutDelegate {

    @IBOutlet var rosterScrollView: JNWCollectionView!

    var roster = EloRoster()
    var delegate:RosterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        rosterTable.setDelegate(self)
//        rosterTable.setDataSource(self)
//        rosterScrollView!.delegate
        
        roster.delegate = self
        roster.initializeData()
        
        
        let listLayout = JNWCollectionViewListLayout(collectionView: rosterScrollView)
        listLayout.rowHeight = 60
        listLayout.delegate = self
        
        rosterScrollView .collectionViewLayout = listLayout
        
        rosterScrollView.registerClass(EXRosterContactCell.self, forCellWithReuseIdentifier: "contactCell")
        
        rosterScrollView.delegate = self
        rosterScrollView.dataSource = self
        rosterScrollView.reloadData()
    }

    //Mark: EloRosterDelegate
    func rosterWillChangeContent() {
        
    }
    
    func roster(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
    }
    func rosterDidChangeContent() {
        rosterScrollView.reloadData()
        
    }
    
    //Mark: JNWCollectionViewDelegate
    func collectionView(collectionView: JNWCollectionView!, didSelectItemAtIndexPath indexPath: NSIndexPath!) {
        if(indexPath.item >= 0 && delegate != nil){
            delegate!.didClickContact(roster.getChatId(indexPath.item))
//            roster.chatWishedByUserAction(indexPath.item);
        }
    }
    
    //Mark: JNWCollectionViewDataSource
    
    func collectionView(collectionView: JNWCollectionView!, numberOfItemsInSection section: Int) -> UInt {
        return UInt(roster.numberOfRows());
    }
    
    /// Asks the data source for the view that should be used for the cell at the specified index path. The returned
    func collectionView(collectionView: JNWCollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> JNWCollectionViewCell! {
        let cell = rosterScrollView.dequeueReusableCellWithIdentifier("contactCell") as! EXRosterContactCell;
        
        cell.setItem(roster.getUser(indexPath.item));
        
        return cell;
    }
}