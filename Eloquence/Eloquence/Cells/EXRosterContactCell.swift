import Foundation
import JNWCollectionView
import XMPPFramework

class EXRosterContactCell:JNWCollectionViewCell {
    
    @IBOutlet var cellView: NSView!
    @IBOutlet var avatarImage: NSImageView!
    @IBOutlet var nameLabel: NSTextField!
    @IBOutlet var viaLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit(frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(self.frame)
    }
    
    private func commonInit(frame:NSRect){
        NSBundle.mainBundle().loadNibNamed("EXRosterContactCell", owner: self, topLevelObjects: nil)
        
        let contentFrame = NSMakeRect(0,0,frame.size.width,frame.size.height)
        self.cellView.frame = contentFrame
        contentView = cellView
        
   /*     nameLabel = NSTextField()
        contentView.addSubview(nameLabel)
        nameLabel.stringValue = "LABEL"
        nameLabel.sizeToFit()*/
    }
    
    
    func setItem(user: EloContactList_Item_CoreDataObject) {
        nameLabel.stringValue = user.bareJidStr;
        viaLabel.stringValue = "via " + user.streamBareJidStr;
    }
}