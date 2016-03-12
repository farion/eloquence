//
//  EloRoster.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 02.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import XMPPFramework

#if os(iOS)

#else
    
#endif

protocol EloRosterDelegate:NSObjectProtocol {
    
    func rosterWillChangeContent();
    func roster(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?);
    func rosterDidChangeContent();
}

class EloRoster:NSObject, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController:NSFetchedResultsController!;
    
    var delegate:EloRosterDelegate?;
    
    override init() {
        super.init()
    }

    func initializeData(){
    
        let request = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject");
        let departmentSort = NSSortDescriptor(key: "jidStr", ascending: true)
        request.sortDescriptors = [departmentSort]
        
        let moc = EloXMPPRosterCoreDataStorage.sharedInstance().mainThreadManagedObjectContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath:nil, cacheName: nil)
        fetchedResultsController.delegate = self
    
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
    
        if(fetchedResultsController.sections!.count > 0){
            let sectionInfo = fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        }else{
            return 0
        }
    }

    func getUser(atIndexPath: NSIndexPath) -> XMPPUserCoreDataStorageObject {
        return fetchedResultsController.objectAtIndexPath(atIndexPath) as! XMPPUserCoreDataStorageObject
    }
    
    /* NSFetchedResultsControllerDelegate */
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        if(delegate != nil){
            delegate!.rosterWillChangeContent()
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if(delegate != nil){
            delegate!.roster(didChangeObject: anObject, atIndexPath:indexPath,forChangeType: type, newIndexPath: newIndexPath)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        if(delegate != nil){
            delegate!.rosterDidChangeContent()
        }
    }
    
}