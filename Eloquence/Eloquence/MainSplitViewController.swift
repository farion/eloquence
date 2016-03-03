//
//  MainSplitViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 01.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa

class MainSplitViewController:NSSplitViewController {
    
    @IBOutlet weak var chatItem: NSSplitViewItem!
    
    @IBOutlet weak var rosterItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}