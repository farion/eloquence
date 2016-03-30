import Foundation
import XMPPFramework

struct EloAccountJid:Hashable {
    let jid:String
    
    var hashValue: Int {
        return jid.hashValue
    }
    
    init(_ jid: String) {
        self.jid = jid
    }
    
    var xmppJid: XMPPJID {
        return XMPPJID.jidWithString(jid)
    }
}

func == (jid1: EloAccountJid, jid2: EloAccountJid) -> Bool {
    return jid1.jid == jid2.jid
}