import Foundation

public struct EloPseudoStructs {
    
}

public class EloChatId:Hashable {
    let from: EloAccountJid
    let to:EloContactJid
    public var hashValue: Int {
        return from.hashValue ^ to.hashValue
    }
    public var toString: String {
        return from.jid + "|" + to.jid
    }
    init(identifier:String){
        let chatParts = identifier.characters.split{$0 == "|"}.map(String.init)
        self.from = EloAccountJid(chatParts[0])
        self.to = EloContactJid(chatParts[1])
    }
    init(from:EloAccountJid,to:EloContactJid){
        self.from = from
        self.to = to
    }
}

public func ==(a: EloChatId, b: EloChatId) -> Bool {
    return a.from == b.from && a.to == b.to
}