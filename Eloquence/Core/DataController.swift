//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import CoreData

class DataController: NSObject {
    
    static let sharedInstance = DataController()
    
    var managedObjectContext: NSManagedObjectContext;
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("DataModel", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            /* The directory the application uses to store the Core Data store file.
            This code uses a file named "DataModel.sqlite" in the application's documents directory.
            */
            let storeURL = docURL.URLByAppendingPathComponent("DataModel.sqlite")
            do {
                try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }
    
    func getAccounts() -> [EloAccount] {
        let accountsFetch = NSFetchRequest(entityName: "Account");
        do {
            let fetchedAccounts = try managedObjectContext.executeFetchRequest(accountsFetch) as! [EloAccount];
            NSLog("count: %d",fetchedAccounts.count);
            return fetchedAccounts;
        } catch {
            fatalError("Failed to fetch accounts: \(error)");
        }
    }
    
    func insertAccount() -> EloAccount {
        return NSEntityDescription.insertNewObjectForEntityForName("Account", inManagedObjectContext: self.managedObjectContext) as! EloAccount;
    }
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func deleteAccount(account: EloAccount?) {
        if(account != nil){
            self.managedObjectContext.deleteObject(account!);
        }
    }
    
    func getAccount(accountId:NSNumber?) -> EloAccount?{

        if(accountId == nil){
            return nil;
        }
        
        let accountsFetch = NSFetchRequest(entityName: "Account");
        accountsFetch.predicate = NSPredicate(format: "objectID == %d", accountId!);
        
        do {
            let fetchedAccounts = try managedObjectContext.executeFetchRequest(accountsFetch) as! [EloAccount];
            if(fetchedAccounts.isEmpty){
                return nil;
            }
            return fetchedAccounts[0];
        } catch {
            fatalError("Failed to fetch accounts: \(error)");
        }
    }
    
}