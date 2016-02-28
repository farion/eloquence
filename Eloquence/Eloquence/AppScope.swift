//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
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
