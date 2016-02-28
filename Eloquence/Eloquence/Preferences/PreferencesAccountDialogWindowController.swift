//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Cocoa

class PreferencesAccountDialogWindowController: NSWindowController {

    @IBOutlet weak var jidText: NSTextField!
    @IBOutlet weak var passwordText: NSTextField!
    @IBOutlet weak var priorityText: NSTextField!
    @IBOutlet weak var resourceText: NSTextField!
    @IBOutlet weak var serverText: NSTextField!
    @IBOutlet weak var portText: NSTextField!
    @IBOutlet weak var autoConnect: NSButton!
    
    var account:EloAccount?;
    
    override func windowDidLoad() {
        super.windowDidLoad()
        fill();
    }

    func setAccountToEdit(account:EloAccount?){
        self.account = account;
        fill();
    }
    
    
    private func fill(){
        
        if(jidText == nil){
            return;
        }
        
        if(account == nil){
            jidText.stringValue = "";
            passwordText.stringValue = "";
            priorityText.stringValue = "";
            resourceText.stringValue = "";
            serverText.stringValue = "";
            portText.stringValue = "";
            autoConnect.state = 0;
        }else{
            let safeAccount = account!;
            jidText.stringValue = safeAccount.getJid()!
            passwordText.stringValue = safeAccount.getPassword()!;
            
            let priority = safeAccount.getPriority();
            
            NSLog("%d",priority!);
            
            if(priority != nil &&  priority > 0){
                priorityText.stringValue = String(priority!);
            }else{
                priorityText.stringValue = "";
            }
            
            resourceText.stringValue = safeAccount.getResource()!;
            serverText.stringValue = safeAccount.getServer()!;
            
            let port = safeAccount.getPort();
            if(port != nil && port > 0){
                portText.stringValue = String(port!)
            }else{
                portText.stringValue = "";
            }
            
            if(safeAccount.isAutoConnect()){
                autoConnect.state = 1;
            }else{
                autoConnect.state = 0;
            }
        }
        
    }
    
    
    @IBAction func clickOk(sender: AnyObject) {
        
        if(account == nil){
            account = DataController.sharedInstance.insertAccount();
        }
        
        let safeAccount = account!;
        safeAccount.jid = jidText.stringValue;
        safeAccount.priority = priorityText.integerValue;
        safeAccount.resource = resourceText.stringValue;
        safeAccount.server = serverText.stringValue;
        safeAccount.port = portText.integerValue;
        safeAccount.autoconnect = autoConnect.state;
        safeAccount.setPassword(passwordText.stringValue);
        DataController.sharedInstance.save();

        self.window?.sheetParent?.endSheet(self.window!, returnCode:NSModalResponseOK);
    }
    
    @IBAction func clickCancel(sender: AnyObject) {
        self.window?.sheetParent?.endSheet(self.window!, returnCode:NSModalResponseCancel);
    }
}
