import Foundation
import JNWCollectionView
import XMPPFramework

class EXMessageViewCell:JNWCollectionViewCell {
    
    @IBOutlet var cellView: NSView!
    @IBOutlet var cellBottomLabel: NSTextField!
    @IBOutlet var avatarImage: NSImageView!
    @IBOutlet var messageContentView: NSView!
    @IBOutlet var textLabel: NSTextField!
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit(frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(self.frame)
    }
    
    private func commonInit(frame:NSRect){

        NSBundle.mainBundle().loadNibNamed(getNibName(), owner: self, topLevelObjects: nil)
        
        
        let contentFrame = NSMakeRect(0,0,frame.size.width,frame.size.height)
        self.cellView.frame = contentFrame
        contentView = cellView
        
        /*     nameLabel = NSTextField()
        contentView.addSubview(nameLabel)
        nameLabel.stringValue = "LABEL"
        nameLabel.sizeToFit()*/
    
    }
    
    /*
    func getHeight() -> Int {
        return 100;
    }*/
    
    
    func setMessage(message: EloMessage) {
        textLabel.stringValue = message.text!
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        cellBottomLabel.stringValue = formatter.stringFromDate(message.timestamp)
 //       nameLabel.stringValue = user.jidStr;
//        viaLabel.stringValue = "via " + user.streamBareJidStr;
    }

    
    
    func getNibName() -> String {
        fatalError("Subclasses need to implement the `getNibName()` method.")
    }
}