//
//  EMAccountsViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 08.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework

protocol EMAccountsViewControllerDelegate:NSObjectProtocol {
    func didClickDoneInAccountsViewController();
}

class EMAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EMAddAccountViewControllerDelegate {
    
    var delegate:EMAccountsViewControllerDelegate?;
    
    var addController: EMAddAccountViewController?;
    
    var data = [EloAccount]();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        self.prepareData();
        
    }
    
    func prepareData(){
        self.data = DataController.sharedInstance.getAccounts();
        tableView.reloadData();
    }
    
    
    @IBAction func doneClicked(sender: AnyObject) {
        if(delegate != nil){
            delegate!.didClickDoneInAccountsViewController()
        }
    }
    
    @IBAction func addClicked(sender: AnyObject) {
        
        addController = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("AddAccount") as? EMAddAccountViewController;
        addController!.delegate = self;
        self.presentViewController(addController!, animated: true, completion: {})
    }
    
    func doCloseAddAccountView(){
        if(addController != nil){
            addController!.dismissViewControllerAnimated(true, completion: nil)
            addController!.delegate = nil;
            addController = nil;
        }
    }

    
    
    //pragma mark - UITableViewDataSource
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
                    var cell = tableView.dequeueReusableCellWithIdentifier("AccountCell", forIndexPath: indexPath) as? EMAccountCell;
            if(cell == nil) {
                cell = EMAccountCell(style: UITableViewCellStyle.Default, reuseIdentifier: "AccountCell");
            }
            cell!.jidLabel.text = data[indexPath.row].getJid();
            cell!.disableSwitch.on = data[indexPath.row].isAutoConnect()
            cell!.account = data[indexPath.row];
            return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    
    //pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        addController = UIStoryboard.init(name: "Shared", bundle: nil).instantiateViewControllerWithIdentifier("AddAccount") as? EMAddAccountViewController;
        addController!.delegate = self;
        addController!.account = data[indexPath.row];
        self.presentViewController(addController!, animated: true, completion: {})
        
        //TODO ui
        let connection = EloConnectionManager.sharedInstance.getConnectionByJid(data[indexPath.row].getJid()!);
        
        NSLog("Tapped %@",data[indexPath.row].getJid()! );
        for capability in connection!.getCapabilities() {
            NSLog("%@",capability);
        }
        
    }

    
}