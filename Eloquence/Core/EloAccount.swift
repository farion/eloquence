import CoreData
import Foundation
import KeychainSwift


class EloAccount: NSManagedObject {
    
    @NSManaged var jid:NSString
    @NSManaged var resource: NSString?
    @NSManaged var port: NSNumber?
    @NSManaged var server: NSString?
    @NSManaged var priority: NSNumber
    @NSManaged var autoconnect: NSNumber
    
    let keychainPasswordPrefix = "Eloquence password for "
    
    func isAutoConnect() -> Bool {
        return autoconnect.boolValue
    }
    
    func setAutoConnect(autoconnect:Bool){
        if(autoconnect){
            self.autoconnect = 1
        } else {
            self.autoconnect = 0
        }
        DataController.sharedInstance.save()
    }
    
    
    func getJid() -> EloAccountJid {
        return EloAccountJid(jid as String)
    }

    func getResource() -> String? {
        return resource as? String
    }
    
    
    func getServer() -> String? {
        return server as? String
    }
    
    func getPort() -> Int? {
        return port as? Int
    }
    
    func getPriority() -> Int {
        return priority as Int
    }
    
    func getPassword() -> String {
        
        let jid = getJid()

        let keychain = KeychainSwift()
        let password = keychain.get(keychainPasswordPrefix + jid.jid)
        
        if(password != nil){
            return password!
        }
        return ""
        
    }
    
    func setPassword(password: String) {
        
        let jid = getJid();
        
        let keychain = KeychainSwift();
        keychain.set(password, forKey: keychainPasswordPrefix + jid.jid);
        
        //directly get again, to trigger permission dialog
        keychain.get(keychainPasswordPrefix + jid.jid);
    }
    
}