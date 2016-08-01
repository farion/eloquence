import Cocoa
import CCNPreferencesWindowController

class PreferencesGeneralViewController: NSViewController, CCNPreferencesWindowControllerProtocol {
    
    var preferenceWindow: NSWindow;
    
    init? (window: NSWindow){
        preferenceWindow = window;
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder: NSCoder) {
        preferenceWindow = NSWindow();
        super.init(coder: coder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func preferenceIdentifier() -> String! {
        return "GeneralPreferencesIdentifier";
    }
    
    func preferenceTitle() -> String! {
        return "General";
    }
    
    func preferenceIcon() -> NSImage! {
        return NSImage(named: NSImageNamePreferencesGeneral);
    }
    
}