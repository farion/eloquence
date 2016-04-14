import Foundation

class EloMessage:NSObject {
    var author: String?
    var text: String?
    var isOutgoing = false
    
    override init() {
        
    }
    
    init(_ object:XMPPMessageArchiveManagement_Message_CoreDataObject){
        isOutgoing = object.isOutgoing
        text = object.body
        if(text == nil){
            text = "Composing ..."
        }
        
        author = "foo"
    }
    
}