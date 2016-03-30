import Foundation
import CoreData
import XMPPFramework

@objc
protocol EloConnectionsDelegate: NSObjectProtocol {
    
}


class EloConnections: MulticastDelegateContainer {
    
    static let sharedInstance = EloConnections();

    typealias DelegateType = EloConnectionsDelegate;
    var multicastDelegate = [EloConnectionsDelegate]()
    
    var connections = [EloAccountJid:EloConnection]();
    
    //TODO threadsafe

    func connectAllAccounts(){
        
        let accounts = DataController.sharedInstance.getAccounts();
        NSLog("%@","connectall");
        
        
        NSLog("accountcount: %d",accounts.count);
        for account in accounts {
            
            let accountJid = account.getJid()
            connections[accountJid] = EloConnection(account: account);
            if(account.isAutoConnect()){
                connections[accountJid]!.connect();
            }
        }
    }
    
    func getXMPPStream(accountJid:EloAccountJid) -> XMPPStream {
        return connections[accountJid]!.getXMPPStream() ; //otherwise it is a bad bug
    }
    
}
// invokeDelegate { $0.method() }