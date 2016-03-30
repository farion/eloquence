import Foundation
import JNWCollectionView
import XMPPFramework

class EXTextMessageCell:JNWCollectionViewCell {
    
    @IBOutlet var cellView: NSView!

    @IBOutlet var text: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit(frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(self.frame)
    }
    
    private func commonInit(frame:NSRect){
        NSBundle.mainBundle().loadNibNamed("EXTextMessageCell", owner: self, topLevelObjects: nil)
        
        let contentFrame = NSMakeRect(0,0,frame.size.width,frame.size.height)
        self.cellView.frame = contentFrame
        contentView = cellView
        
        /*     nameLabel = NSTextField()
        contentView.addSubview(nameLabel)
        nameLabel.stringValue = "LABEL"
        nameLabel.sizeToFit()*/
    }
    
    
    func setItem(message: EloMessage) {
        text.stringValue = message.text!
 //       nameLabel.stringValue = user.jidStr;
//        viaLabel.stringValue = "via " + user.streamBareJidStr;
    }
}