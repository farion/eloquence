import Cocoa
import XMPPFramework

class MainWindowController: NSWindowController {
    
    private let preferences = CCNPreferencesWindowController();

    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.window!.titleVisibility = NSWindowTitleVisibility.Hidden;
        self.window!.titlebarAppearsTransparent = true;
        self.window!.styleMask |= NSFullSizeContentViewWindowMask;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPreferences:", name: EloConstants.SHOW_PREFERENCES, object: nil)
        
        //TODO move to subclass?
        preferences.centerToolbarItems = true;
        preferences.setPreferencesViewControllers([
            PreferencesGeneralViewController(window: preferences.window!)!,
            PreferencesAccountViewController(window: preferences.window!)!
            ])
        
    }
    
    func showPreferences(){
        preferences.showPreferencesWindow();
        
    }

}
