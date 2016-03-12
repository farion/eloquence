//
//  EMAddAccountViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 08.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

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
    
    
    override func viewWillAppear(animated: Bool) {
        if(account != nil){
            titleBar!.items![0].title = "Account Details"
            jidField.text = account!.getJid()
            passwordField.text = account!.getPassword()
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
        safeAccount.jid = jidField.text;
/*        safeAccount.priority = priorityText.integerValue;
        safeAccount.resource = resourceText.stringValue;
        safeAccount.server = serverText.stringValue;
        safeAccount.port = portText.integerValue;
        safeAccount.autoconnect = autoConnect.state;*/
        safeAccount.setPassword(passwordField.text!);
        DataController.sharedInstance.save();

        
        close();
    }
    
    func close(){
        if(delegate != nil){
            delegate!.doCloseAddAccountView();
        }
    }
}
