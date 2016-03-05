//
//  PhoneMainViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 04.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit

class PhoneMainViewController:UIViewController, EloGlobalEventActivateContactDelegate{
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
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

        
        EloGlobalEvents.sharedInstance.registerDelegate(self);
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
        })


    }
    
    /** DELEGATE **/
    func contactActivated(contact: EloContact) {
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


    }
    
    func didReceiveChat(msg: EloMessage) {

    }
}