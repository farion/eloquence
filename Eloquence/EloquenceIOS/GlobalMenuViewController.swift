//
//  GlobalMenuViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 05.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import UIKit

class GlobalMenuViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum ItemType {
        case Accounts
        case Preferences
    }
    
    struct Item {
        var type:ItemType;
        var name = "";
        var groups:[Group];
    }
    
    enum Group {
        case Roster
        case Message
    }
    
    
    let items = [
        Item(type: ItemType.Accounts, name:"Accounts", groups: [Group.Roster, Group.Message] ),
        Item(type: ItemType.Preferences, name:"Preferences", groups: [Group.Roster, Group.Message] )
    ];
 
    var currentGroup = Group.Roster
    var currentItems = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.modalInPopover = false;
        initItems();
        
//        tableView.registerClass(GlobalMenuCell.self, forCellReuseIdentifier: "GlobalMenuCell");
        
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WYSettingsTableViewCell"];
    
    //[self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:195./255. green:4./255. blue:94./255. alpha:1.]];
        tableView.delegate = self;
        tableView.dataSource = self;
        
    }
    
    override func viewWillAppear(animated: Bool){
        //NSLog(@"view WILL appear");
    }
    
    override func viewDidAppear(animated: Bool){
    //NSLog(@"view DID appear");
    }
    
    override func viewWillDisappear(animated: Bool){
    //NSLog(@"view WILL disappear");
    }
    
    override func viewDidDisappear(animated: Bool){
        //NSLog(@"view DID disappear");
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    //pragma mark - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "";
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

    //UITableViewCell* cell = [aTableView dequeueReusableCellWithIdentifier:@"WYSettingsTableViewCell" forIndexPath:indexPath];
        var cell = tableView.dequeueReusableCellWithIdentifier("GlobalMenuCell", forIndexPath: indexPath) as? GlobalMenuCell;
        
      if(cell == nil) {
        cell = GlobalMenuCell(style: UITableViewCellStyle.Default, reuseIdentifier: "GlobalMenuCell");
        }

        self.updateCell(cell!, indexPath:indexPath);
    
        return cell!;
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true);

        switch(items[indexPath.row].type){
            case ItemType.Accounts:
                NSNotificationCenter.defaultCenter().postNotificationName(EMNotification.SHOW_ACCOUNTS, object: self);
            break
            case ItemType.Preferences:
                NSNotificationCenter.defaultCenter().postNotificationName(EMNotification.SHOW_PREFERENCES, object: self);
            break
        }
        
        
    }
    
    //#pragma mark - Private
    func updateCell(cell: GlobalMenuCell, indexPath: NSIndexPath){
        
        cell.textLabel?.text = items[indexPath.row].name;
    }
    
    func initItems(){
        
        currentItems = [Item]()
        
        var height:CGFloat = 0;
        
        for item in items {
            if(item.groups.contains(currentGroup)){
                height += 44;
                currentItems.append(item);
            }
        }
        
        self.preferredContentSize = CGSizeMake(200, height);
    }
    
}