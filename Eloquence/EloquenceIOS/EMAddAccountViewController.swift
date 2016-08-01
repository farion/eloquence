import Foundation
import UIKit

protocol EMAddAccountViewControllerDelegate:NSObjectProtocol {
    func doCloseAddAccountView();
}

class EMAddAccountViewController:UIViewController {
    
    var delegate:EMAddAccountViewControllerDelegate?
    
    var account:EloAccount?;
    
    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var jidField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet var advancedSettingsSwitch: UISwitch!
    @IBOutlet weak var infoText: UILabel!
    
    @IBOutlet var priorityLabel: UILabel!
    @IBOutlet var priorityField: UITextField!
    
    @IBOutlet var resourceLabel: UILabel!
    @IBOutlet var resourceField: UITextField!
    
    @IBOutlet var serverLabel: UILabel!
    @IBOutlet var serverField: UITextField!
    
    @IBOutlet var portLabel: UILabel!
    @IBOutlet var portField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        if(account != nil){
            
            let safeAccount = account!
            
            titleBar!.items![0].title = "Account Details"
            jidField.text = safeAccount.getJid().jid
            passwordField.text = safeAccount.getPassword()
            
            var infoTextString = "Server Info";
                
            let capabilities = EloCapabilities().getCapabilities(safeAccount.getJid())
                
            for capability in capabilities {
                var supported = "No"
                if(capability.supportedByServer){ supported = "Yes" }
                infoTextString.appendContentsOf("\n" + capability.xep + " " + capability.name + "\t" + supported)
            }
            
            infoText.sizeToFit()
            if(capabilities.count == 0){
                infoText.numberOfLines = 2
                infoTextString.appendContentsOf("Account currently offline")
            }else{
                infoText.numberOfLines = 1 + capabilities.count
            }
            infoText.text = infoTextString
            
        }else{
             titleBar!.items![0].title = "New Account"
        }
    }
    
    @IBAction func cancelClick(sender: AnyObject) {
        close();
    }
    
    @IBAction func saveClick(sender: AnyObject) {
        
        
        if(account == nil){
            account = DataController.sharedInstance.insertAccount();
        }
        
        let safeAccount = account!;
        safeAccount.jid = NSString(UTF8String: jidField.text!)!;
        
        if(priorityField.text != nil){
            let priority = Int(priorityField.text!);
            if(priority != nil){
                safeAccount.priority = priority!;
            }
        }
        
        if(priorityField.text != nil){
            safeAccount.resource = resourceField.text;
        }
        
        safeAccount.server = serverField.text;
        
        if(portField.text != nil){
            let port = Int(portField.text!);
            if(port != nil){
                safeAccount.port = port!;
            }
        }

        safeAccount.autoconnect = 1; //autoConnect.state; TODO
        
        if(passwordField.text != nil){
            safeAccount.setPassword(passwordField.text!);
        }
        
        DataController.sharedInstance.save();

        
        close();
    }
    
    @IBAction func toggleAdvancedSettings(sender: AnyObject) {
        if(advancedSettingsSwitch.on){
            priorityLabel.hidden = false
            priorityField.hidden = false
            resourceLabel.hidden = false
            resourceField.hidden = false
            serverLabel.hidden = false
            serverField.hidden = false
            portLabel.hidden = false
            portField.hidden = false
        }else{
            priorityLabel.hidden = true
            priorityField.hidden = true
            resourceLabel.hidden = true
            resourceField.hidden = true
            serverLabel.hidden = true
            serverField.hidden = true
            portLabel.hidden = true
            portField.hidden = true
        }
    }
    
    func close(){
        if(delegate != nil){
            delegate!.doCloseAddAccountView();
        }
    }
}
