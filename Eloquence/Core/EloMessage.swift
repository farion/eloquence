import Foundation

class EloMessage:NSObject {
    var author: String?
    var text: String?
    var isOutgoing = false
    let timestamp: NSDate
    
    override init() {
        timestamp = NSDate()
    }
    
    init(_ object:EloXMPPMessageArchiveManagement_Message_CoreDataObject){
        isOutgoing = object.isOutgoing
        timestamp = object.timestamp
        text = object.body
        if(text == nil){
            text = "Composing ..."
        }
        
        author = "foo"
    }
    
}