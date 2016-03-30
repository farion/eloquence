import Foundation
import UIKit
import XMPPFramework

class RosterViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, EloRosterDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var roster = EloRoster()
    
    @IBOutlet var rosterScrollView: NSScrollView!
    @IBOutlet var rosterScrollView: NSScrollView!
    @IBOutlet weak var rosterScrollView: NSScrollView!
    @IBOutlet weak var rosterScrollView: NSScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        roster.delegate = self
        roster.initializeData()
    }
    
    /* private */
    
    func configureCell(cell:RosterCell, atIndexPath: NSIndexPath){
        let user = roster.getUser(atIndexPath.row);
        cell.name.text = user.displayName
        cell.viaLabel.text = "via " + user.streamBareJidStr!
        cell.imageView!.image = user.photo;
    }
    
    /* UITableViewDataSource */
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.numberOfRowsInSection(section);
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCellWithIdentifier("RosterCell") as! RosterCell
        configureCell(cell,atIndexPath:indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        roster.chatWishedByUserAction(indexPath.row)
    }
    
    /* NSFetchedResultsControllerDelegate */
    
    func rosterWillChangeContent() {
        NSLog("rosterwillchange")
        tableView.beginUpdates()
    }
    
    func roster(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch(type){
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Delete:
                tableView.deleteRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
            case .Update:
                configureCell(tableView.cellForRowAtIndexPath(indexPath!) as! RosterCell ,atIndexPath: indexPath!)
                break
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
                break
        }
    }
    
    func rosterDidChangeContent() {
        tableView.endUpdates()
    }
}
