//
//  MainWindowController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 19.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window!.titleVisibility = .Hidden;
    }

    @IBAction func toolbarPreferencesClicked(sender: AnyObject) {
            AppScope.instance.openPreferences();
    }
    @IBAction func toolbarReloadClicked(sender: AnyObject) {
        EloChatManager.sharedInstance.connectAllAccounts();
    }
}
