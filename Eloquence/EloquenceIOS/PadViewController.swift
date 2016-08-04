import Foundation
import UIKit

class PadViewController: UIViewController {
    
    @IBOutlet weak var rosterView: UIView!
    @IBOutlet weak var messageView: UIView!
    
    override func viewDidLoad() {
        
        let roster = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Roster") as! RosterViewController
        
        
        roster.view.frame = rosterView.bounds
        rosterView.addSubview(roster.view);
        addChildViewController(roster);
        roster.didMoveToParentViewController(self);
        
        let message = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Message") as! MessageViewController
        
        message.view.frame = messageView.bounds
        messageView.addSubview(message.view);
        addChildViewController(message);
        message.didMoveToParentViewController(self);
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
}