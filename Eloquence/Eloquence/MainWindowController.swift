import Cocoa
import XMPPFramework

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden;
        self.window!.titlebarAppearsTransparent = true;
        self.window!.styleMask |= NSFullSizeContentViewWindowMask;
    }

}
