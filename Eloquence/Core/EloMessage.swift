import Foundation

class EloMessage:NSObject {
    var author: String?;
    var text: String?;
    
    override init() {
        
    }
    
    init(_ object:XMPPMessageArchiveManagement_Message_CoreDataObject){
        text = object.body
        if(text == nil){
            text = "Composing ..."
        }
        
        author = "foo"
    }
}