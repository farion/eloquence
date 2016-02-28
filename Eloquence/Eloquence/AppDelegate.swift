//
//  AppDelegate.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 18.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
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
    
    @IBAction func preferenceMenuItemClicked(sender: AnyObject) {
        AppScope.instance.openPreferences();
    }
    
}

