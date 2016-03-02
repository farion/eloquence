//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Cocoa
import CocoaLumberjack

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let ddLogLevel:DDLogLevel = DDLogLevel.All;
        
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLevel: ddLogLevel);
        
        EloChatManager.sharedInstance.connectAllAccounts();
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        // TODO disconnect
    }
    
    @IBAction func reloadRosterMenuItemClicked(sender: AnyObject) {
        
    }
    
    
    @IBAction func preferenceMenuItemClicked(sender: AnyObject) {
        AppScope.instance.openPreferences();
    }
    
}

