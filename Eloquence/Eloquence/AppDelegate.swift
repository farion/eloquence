//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Cocoa
import CocoaLumberjack
import CCNPreferencesWindowController
import HockeySDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private let preferences = CCNPreferencesWindowController();
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application

        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("0fd88936cfd143e381f53122a3ace4a7")
        // Do some additional configuration if needed here
        BITHockeyManager.sharedHockeyManager().startManager()
        
        let ddLogLevel:DDLogLevel = DDLogLevel.All;
        
        DDLog.addLogger(DDTTYLogger.sharedInstance(), withLevel: ddLogLevel);
        
        //TODO move to subclass?
        preferences.centerToolbarItems = true;
        preferences.setPreferencesViewControllers([
            PreferencesGeneralViewController(window: preferences.window!)!,
            PreferencesAccountViewController(window: preferences.window!)!
            ])

        EloConnections.sharedInstance.connectAllAccounts();
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        // TODO disconnect
    }
    
    @IBAction func reloadRosterMenuItemClicked(sender: AnyObject) {
        
    }
    
    
    @IBAction func preferenceMenuItemClicked(sender: AnyObject) {
        preferences.showPreferencesWindow();
    }
    
}

