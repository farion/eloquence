import Foundation
import XMPPFramework


protocol EloRosterDelegate:NSObjectProtocol {
    
    func rosterWillChangeContent();
    func roster(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?);
    func rosterDidChangeContent();
}

class EloRoster:NSObject, EloFetchedResultsControllerDelegate {
    
    var fetchedResultsController: EloFetchedResultsController!;
    
    var delegate:EloRosterDelegate?;
    
    override init() {
        super.init()
    }

    func initializeData(){
    
        let request = NSFetchRequest(entityName: "EloContactList_Item_CoreDataObject");
        let departmentSort = NSSortDescriptor(key: "bareJidStr", ascending: true)
        request.sortDescriptors = [departmentSort]
        
        let moc = EloContactListCoreDataStorage.sharedInstance().mainThreadManagedObjectContext
        
        initFRC(request,managedObjectContext: moc);
        fetchedResultsController.delegate = self
    
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
#if os(iOS)
    func initFRC(request: NSFetchRequest, managedObjectContext: NSManagedObjectContext){
        fetchedResultsController = EloFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath:nil, cacheName: nil)
    }
#else
    func initFRC(request: NSFetchRequest, managedObjectContext: NSManagedObjectContext){
        fetchedResultsController = EloFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext)
    }
#endif
    
#if os(iOS)
    func numberOfRowsInSection(section: Int) -> Int {
    
        if(fetchedResultsController.sections!.count > 0){
            let sectionInfo = fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        }else{
            return 0
        }
    }
#else
    
    func numberOfRows() -> Int {
        return fetchedResultsController.fetchedObjects!.count;
    }
    
#endif
    
    
    

    func getContactListItem(index: Int) -> EloContactList_Item_CoreDataObject {
#if os(iOS)
        return fetchedResultsController.objectAtIndexPath(NSIndexPath(forItem: index, inSection: 0) ) as! EloContactList_Item_CoreDataObject
#else
        return fetchedResultsController.fetchedObjects![index] as! EloContactList_Item_CoreDataObject
#endif
    }
    
    func chatWishedByUserAction(index:Int) {
        let contactListItem = getContactListItem(index);
        let chatId = EloChatId(from: EloAccountJid(contactListItem.streamBareJidStr) ,to: EloContactJid(contactListItem.bareJidStr))
        NSNotificationCenter.defaultCenter().postNotificationName(EloConstants.ACTIVATE_CONTACT, object: chatId)

    }
    
    func getChatId(index:Int) -> EloChatId {
        let contactListItem = getContactListItem(index);
        return EloChatId(from: EloAccountJid(contactListItem.streamBareJidStr) ,to: EloContactJid(contactListItem.bareJidStr))
    }
    
    /* EloFetchedResultsControllerDelegate */
    
    func controllerWillChangeContent(controller: EloFetchedResultsController) {
        if(delegate != nil){
            delegate!.rosterWillChangeContent()
        }
    }
    
#if os(iOS)
    func controller(controller: EloFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if(delegate != nil){
            delegate!.roster(didChangeObject: anObject, atIndexPath:indexPath,forChangeType: type, newIndexPath: newIndexPath)
        }
    }
    #else
    func controller(controller: EloFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndex index: UInt, forChangeType type: EloFetchedResultsChangeType, newIndex: UInt) {
        if(delegate != nil){
            delegate!.roster(didChangeObject: anObject, atIndexPath:NSIndexPath(index: Int(index)),forChangeType: type, newIndexPath: NSIndexPath(index:Int(newIndex)))
        }
    }
    
    #endif
    
    
    func controllerDidChangeContent(controller: EloFetchedResultsController) {
        NSLog("Didchange")
        if(delegate != nil){
            delegate!.rosterDidChangeContent()
        }
    }
    
}