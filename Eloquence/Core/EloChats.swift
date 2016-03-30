import Foundation
import XMPPFramework

class EloChats {
    
    static let sharedInstance = EloChats();
        
    var chats = [EloChatId:EloChat]()

    func getChat(from: EloAccountJid, to:EloContactJid) -> EloChat {

        let chatId = EloChatId(from: from, to: to)
        
        if(chats[chatId] == nil){
            chats[chatId] = EloChat(from:from, to:to);
        }
        
        return chats[chatId]!;
    }
}

