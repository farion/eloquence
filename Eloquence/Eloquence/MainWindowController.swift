//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
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
