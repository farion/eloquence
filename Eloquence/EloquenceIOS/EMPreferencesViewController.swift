import Foundation
import UIKit

protocol EMPreferencesViewControllerDelegate: NSObjectProtocol {
    
    func didClickDoneInPreferencesViewController();
}

class EMPreferencesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var delegate:EMPreferencesViewControllerDelegate?;
    
    enum SettingsType {
        case Toggle
    }
    
    struct SettingsItem {
        var id = "";
        var type: SettingsType;
        var name = "";
        var description = "";
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
                    description: "Allow others to see you online state and ask for seeing their states.")
                ]
            )
    ];
    


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
        
        
    }

    
    
}
