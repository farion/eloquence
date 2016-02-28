//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Foundation


class ErrorDialog {
    
    func showError(msg:String){
        let alert = NSAlert();
        alert.messageText = "Error";
        alert.addButtonWithTitle("OK");
        alert.informativeText = msg;
        
        let windowWithKeyboardAccess = NSApplication.sharedApplication().keyWindow;
        
        if(windowWithKeyboardAccess != nil) {
            alert.beginSheetModalForWindow(windowWithKeyboardAccess!, completionHandler: nil );
        }
        
        //TODO also do a real window in case of no window active
    }
}


