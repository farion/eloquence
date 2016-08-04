import Foundation
import UIKit
import WYPopoverController;
import XMPPFramework

class PhoneMainViewController:UIViewController, WYPopoverControllerDelegate, EMPreferencesViewControllerDelegate, EMAccountsViewControllerDelegate{
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var toolbar: UINavigationBar!
    
    @IBOutlet weak var titleItem: UINavigationItem!
    
    var settingsPopoverController:WYPopoverController?;
    
    var preferencesController:EMPreferencesViewController?;
    var accountsController:EMAccountsViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let roster = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Roster") as! RosterViewController
        
        roster.view.frame = mainView.bounds
        mainView.addSubview(roster.view);
        addChildViewController(roster);
        roster.didMoveToParentViewController(self);
        
        let message = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Message") as! MessageViewController
        
        message.view.frame = secondView.bounds
        secondView.addSubview(message.view);
        addChildViewController(message);
        message.didMoveToParentViewController(self);

        secondView.hidden = true;
        backButton.enabled = false;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAccounts", name: EloConstants.SHOW_ACCOUNTS, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPreferences", name: EloConstants.SHOW_PREFERENCES, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showMessage:", name: EloConstants.ACTIVATE_CONTACT, object: nil)
    }
    
    @IBAction func backClicked(sender: AnyObject) {
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .AllowUserInteraction,
            animations: {
                self.secondView.frame.origin.x = self.secondView.frame.width-80;
            },
            completion: { finished in
                self.backButton.enabled = false;
                self.titleItem.title = "Eloquence"
        })


    }
    
    func close(){
        settingsPopoverController!.dismissPopoverAnimated(false, completion: {
            self.popoverControllerDidDismissPopover(self.settingsPopoverController!);
        });
    }
    
    @IBAction func menuClicked(sender: AnyObject) {
        
        if (settingsPopoverController == nil)
        {
            let btn = sender as! UIBarButtonItem;
        
            let view = toolbar.subviews[3];
        
            
            let settings = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("GlobalMenu") ;
            
            settingsPopoverController = WYPopoverController(contentViewController: settings);
            settingsPopoverController!.delegate = self;
            settingsPopoverController!.passthroughViews = [btn];
            settingsPopoverController!.popoverLayoutMargins = UIEdgeInsetsMake(10, 10, 10, 10);
            settingsPopoverController!.wantsDefaultContentAppearance = false;
            settingsPopoverController!.theme.fillTopColor = UIColor(white: 1, alpha: 1);
  
            settingsPopoverController!.presentPopoverFromRect(
                view.bounds,
                inView: view,
                permittedArrowDirections:WYPopoverArrowDirection.Any,
                animated:true);
            
            }
        else
        {
            close();
        }    
    }
    

    func showMessage(notification: NSNotification) {
        
        if(secondView.hidden){
            secondView.hidden = false;
            secondView.frame.origin.x = secondView.frame.width;
        }
        UIView.animateWithDuration(0.3,
            delay: 0.0,
            options: .AllowUserInteraction,
            animations: {
                self.secondView.frame.origin.x = 0;
            },
            completion: { finished in
                self.backButton.enabled = true;
        })
        
        let chatId = notification.object as! EloChatId
        
        self.titleItem.title = chatId.to.jid

    }
    
    func didReceiveChat(msg: EloMessage) {

    }
    
    
    
    func popoverControllerDidDismissPopover(controller:WYPopoverController?) {
        if(settingsPopoverController != nil){
            settingsPopoverController!.dismissPopoverAnimated(true);
            settingsPopoverController!.delegate = nil;
            settingsPopoverController = nil;
        }
    }
    
    //pragma EMPreferencesViewControllerDelegate
    func didClickDoneInPreferencesViewController(){
        if(preferencesController != nil){
            preferencesController!.dismissViewControllerAnimated(true, completion: nil)
            preferencesController!.delegate = nil;
            preferencesController = nil;
        }
    }
    
    //pragma EMAccountsViewControllerDelegate
    func didClickDoneInAccountsViewController(){
        if(accountsController != nil){
            accountsController!.dismissViewControllerAnimated(true, completion: nil)
            accountsController!.delegate = nil;
            accountsController = nil;
        }
    }
    
    //private
    
    func showAccounts() {
        popoverControllerDidDismissPopover(settingsPopoverController);
        
        accountsController = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Accounts") as? EMAccountsViewController;
        accountsController!.delegate = self;
        self.presentViewController(accountsController!, animated: true, completion: {})
    }
    
    func showPreferences() {
        popoverControllerDidDismissPopover(settingsPopoverController);
        
        preferencesController = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("Preferences") as? EMPreferencesViewController;
        preferencesController!.delegate = self;
        self.presentViewController(preferencesController!, animated: true, completion: {})
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    

}