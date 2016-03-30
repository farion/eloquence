import Foundation
import UIKit


class EMAccountCell:UITableViewCell {
    

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var disableSwitch: UISwitch!
    @IBOutlet weak var jidLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    
    var account:EloAccount!;
    
    @IBAction func toggleAvailability(sender: UISwitch) {
        account.setAutoConnect(sender.on);
    }
    
}