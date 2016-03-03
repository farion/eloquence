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
    
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden;
        self.window!.titlebarAppearsTransparent = true;
        self.window!.styleMask |= NSFullSizeContentViewWindowMask;
        
        
        
    }

}
