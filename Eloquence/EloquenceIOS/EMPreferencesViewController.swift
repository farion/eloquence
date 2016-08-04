import Foundation
import UIKit
import MBProgressHUD

protocol EMPreferencesViewControllerDelegate: NSObjectProtocol {
    
    func didClickDoneInPreferencesViewController();
}


class EMPreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate:EMPreferencesViewControllerDelegate?;
    
    enum SettingsType {
        case Toggle
        case Button
    }
    
    struct SettingsItem {
        var id = "";
        var type: SettingsType;
        var name = "";
        var description = "";
        var action: Selector;
    }
    
    struct Groups {
        var name = "";
        var items: [SettingsItem];
    }
    
    let content = [
        Groups(
            name: "General",
            items: [
                SettingsItem(
                    id: "showOnlineStatus",
                    type:  SettingsType.Toggle,
                    name: "Online-Status",
                    description: "Allow others to see you online state and ask for seeing their states.",
                    action: nil),
                SettingsItem(
                    id: "clearHistory",
                    type: SettingsType.Button,
                    name: "Clear Local History",
                    description: "This will clear all local stored messages. In case your server supports XEP-0313 the history will be reloaded.",
                    action: #selector(EMPreferencesViewController.clearHistory)
                )
            ]
        )
    ];
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WYSettingsTableViewCell"];
        
//        tableView.registerClass(EMPreferencesSwitchCell.self, forCellReuseIdentifier: "PreferencesSwitchCell")
        
        tableView.delegate = self;
        tableView.dataSource = self;

    }
    
    @IBAction func doneClicked(sender: AnyObject) {
        if(delegate != nil){
            delegate!.didClickDoneInPreferencesViewController()
        }
    }
    
    func clearHistory(){
        
        let clearHistoryHandler = { (action:UIAlertAction!) -> Void in
           
            let progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            progressHUD.labelText = "Clearing History ..."
            
            var success = true;
            
            dispatch_async(dispatch_get_main_queue()) {
                
                //TODO move that functionality to core
                
                let moc = EloXMPPMessageArchiveManagementWithContactCoreDataStorage.sharedInstance().mainThreadManagedObjectContext
                
                let fetchRequest = NSFetchRequest()
                fetchRequest.entity = NSEntityDescription.entityForName("EloXMPPMessageArchiveManagement_Message_CoreDataObject", inManagedObjectContext: moc!)
                fetchRequest.includesPropertyValues = false
                do {
                    if let results = try moc!.executeFetchRequest(fetchRequest) as? [NSManagedObject] {
                        for result in results {
                            moc!.deleteObject(result)
                        }
                        
                        try moc!.save()
                    }

                } catch {
                    success = false;
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    progressHUD.hide(true)
                    
                    if(success){
                        let successController = UIAlertController(title: "Success", message: "Your local history was cleared.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        successController.addAction(okAction)
                        self.presentViewController(successController, animated: true, completion: nil)
                    }else{
                        let errorController = UIAlertController(title: "Error", message: "Sorry, your local history was not cleared.", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        errorController.addAction(okAction)
                        self.presentViewController(errorController, animated: true, completion: nil)
                    }
                }
            }
        }
        
        let alertController = UIAlertController(title: "Clear Local History", message: "Do you really want to clear the local history. This can not be undone. Nevertheless if your server supports XEP-0313 your history will be reloaded.", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "Yes", style: .Default, handler: clearHistoryHandler)
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "No", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    //pragma mark - UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return content[section].name;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = content[indexPath.section].items[indexPath.row];
        
        switch(item.type){
            case SettingsType.Toggle:
                  var cell = tableView.dequeueReusableCellWithIdentifier("PreferencesSwitchCell", forIndexPath: indexPath) as? EMPreferencesSwitchCell;
                  if(cell == nil) {
                    cell = EMPreferencesSwitchCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PreferencesSwitchCell");
                  }
                  cell!.nameText.text = item.name;
                  cell!.descriptionText.text = item.description;
                  return cell!;
            
            case SettingsType.Button:
                var cell = tableView.dequeueReusableCellWithIdentifier("PreferencesButtonCell", forIndexPath: indexPath) as? EMPreferencesButtonCell;
                if(cell == nil) {
                    cell = EMPreferencesButtonCell(style: UITableViewCellStyle.Default, reuseIdentifier: "PreferencesButtonCell");
                }
                cell!.nameText.text = item.name;
                cell!.descriptionText.text = item.description;
                return cell!;

            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content[section].items.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return content.count
    }
    
    //pragma mark - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true);
        
        let item = content[indexPath.section].items[indexPath.row];
        
        switch(item.type){
            case SettingsType.Button:
                self.performSelector(item.action);
                break;
            default:
                break;
        }
        
        
    }

    
    
}
