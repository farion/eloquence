
import Cocoa

class PreferencesAccountViewController: NSViewController, CCNPreferencesWindowControllerProtocol {

    var data = [EloAccount]();
    let accountDialog = PreferencesAccountDialogWindowController.init(windowNibName:"PreferencesAccountDialogWindowController");
    
    @IBOutlet weak var tableView: NSTableView!
    
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

        tableView.setDelegate(self);
        tableView.setDataSource(self);
        self.prepareData();
        
    }
    
    func prepareData(){
        
        self.data = DataController.sharedInstance.getAccounts();
        tableView.reloadData();
        
    }
    
    func preferenceIdentifier() -> String! {
        return "AccountPreferencesIdentifier";
    }
    
    func preferenceTitle() -> String! {
        return "Accounts";
    }
    
    func preferenceIcon() -> NSImage! {
        return NSImage(named: NSImageNameUserAccounts);
    }
    
    @IBAction func addClicked(sender: AnyObject) {
        accountDialog.setAccountToEdit(nil);
        preferenceWindow.beginSheet(accountDialog.window! , completionHandler: { (returnCode: NSModalResponse) in
            if(returnCode == NSModalResponseOK){
                self.prepareData();
            }
        });
    }
    
    @IBAction func removeClicked(sender: AnyObject) {
        
        for (_,index) in tableView.selectedRowIndexes.enumerate() {
            DataController.sharedInstance.deleteAccount(self.data[index]);
        }
        self.prepareData();
    }
    
    @IBAction func editClicked(sender: AnyObject) {
        for (_,index) in tableView.selectedRowIndexes.enumerate() {
            accountDialog.setAccountToEdit(self.data[index]);
            preferenceWindow.beginSheet(accountDialog.window! , completionHandler: { (returnCode: NSModalResponse) in
                if(returnCode == NSModalResponseOK){
                    self.prepareData();
                }
            });
        }
    }
}

extension PreferencesAccountViewController : NSTableViewDataSource {
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.data.count;
    }
}


extension PreferencesAccountViewController : NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeViewWithIdentifier("account", owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = (self.data[row].getJid().jid as String);
            return cell
        }
        return nil
    }
}
