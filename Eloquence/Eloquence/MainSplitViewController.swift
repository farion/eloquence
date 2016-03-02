//
//  MainSplitViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 01.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa

class MainSplitViewController:NSSplitViewController, RosterViewControllerDelegate {
    
    @IBOutlet weak var chatItem: NSSplitViewItem!
    
    @IBOutlet weak var rosterItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        (rosterItem.viewController as! RosterViewController).delegate = self;
        
    }
    
    func contactActivated(jid: String) {
        //TODO
    }
}