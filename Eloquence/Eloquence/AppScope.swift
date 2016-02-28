//
//  AppScope.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 18.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation

class AppScope {

    static let instance = AppScope()
    var preferences = CCNPreferencesWindowController();
    
    init() {
        preferences.centerToolbarItems = true;
        preferences.setPreferencesViewControllers([
            PreferencesGeneralViewController(window: preferences.window!)!,
            PreferencesAccountViewController(window: preferences.window!)!
            ])
        
    }
    
    func openPreferences() {
        preferences.showPreferencesWindow();
    }
}
