import Foundation
import XMPPFramework

protocol EloChatDelegate {
    func didReceiveMessage(msg: EloMessage)
    func didFailSendMessage(msg: EloMessage)
    
    func chatWillChangeContent()
    func chat(didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    func chatDidChangeContent()
    
    
}

enum EloChatError:ErrorType {
  case NotConnected
}

class EloChat:NSObject, XMPPStreamDelegate, EloFetchedResultsControllerDelegate {
    
    var delegate: EloChatDelegate?
    
    let from:EloAccountJid
    let to:EloContactJid
    let xmppStream:XMPPStream
    var fetchedResultsController: EloFetchedResultsController!;
    
    init(from: EloAccountJid, to: EloContactJid){
        self.from = from
        self.to = to
        xmppStream = EloConnections.sharedInstance.getXMPPStream(from)
        
        super.init()
        
        xmppStream.addDelegate(self, delegateQueue: GlobalUserInteractiveQueue)
        
        let moc = XMPPMessageArchiveManagementCoreDataStorage.sharedInstance().mainThreadManagedObjectContext
        
        let predicate = NSPredicate(format: "bareJidStr == %@ AND streamBareJidStr = %@",to.xmppJid.bare(),from.xmppJid.bare());
        
        let request = NSFetchRequest(entityName: "XMPPMessageArchiveManagement_Message_CoreDataObject");
        request.predicate = predicate;
        let departmentSort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [departmentSort]
        
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
    
    func getMessage(index: Int) -> XMPPMessageArchiveManagement_Message_CoreDataObject {
        #if os(iOS)
            return fetchedResultsController.objectAtIndexPath(NSIndexPath(index: index)) as! XMPPMessageArchiveManagement_Message_CoreDataObject
        #else
            return fetchedResultsController.fetchedObjects![index] as! XMPPMessageArchiveManagement_Message_CoreDataObject
        #endif
    }
    
    
    private func getXMPPStream() throws -> XMPPStream {
        
        if(xmppStream.isConnected()){
                return xmppStream
        }
        
        throw EloChatError.NotConnected
    }
    
    func sendTextMessage(text: String) {
        
        let msg = XMPPMessage(type: "chat", to: to.xmppJid );
        msg.addBody(text);
        
        do {
            let xmppStream = try getXMPPStream();
            xmppStream.sendElement(msg);
        } catch {
            if(delegate != nil){
                delegate!.didFailSendMessage(EloMessage())
            }
        }
    }
    
    
    @objc func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {

        if(message.from().bare() == to.jid){
            if(delegate != nil){
                if(message.isChatMessageWithBody()){
                    let msg = EloMessage();
                    msg.author = to.jid;
                    msg.text = to.jid + ": " + message.body();
                    delegate!.didReceiveMessage(msg);
                }
            }
        }
    }
    
    
    func controllerWillChangeContent(controller: EloFetchedResultsController) {
        if(delegate != nil){
            delegate!.chatWillChangeContent()
        }
    }
    
    #if os(iOS)
    func controller(controller: EloFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: EloFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if(delegate != nil){
            delegate!.chat(didChangeObject: anObject, atIndexPath:indexPath,forChangeType: type, newIndexPath: newIndexPath)
        }
    }
    #else
    func controller(controller: EloFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndex index: UInt, forChangeType type: EloFetchedResultsChangeType, newIndex: UInt) {
        if(delegate != nil){
            delegate!.chat(didChangeObject: anObject, atIndexPath:NSIndexPath(index: Int(index)),forChangeType: type, newIndexPath: NSIndexPath(index:Int(newIndex)))
        }
    }
    
    #endif
    
    
    func controllerDidChangeContent(controller: EloFetchedResultsController) {
        NSLog("Didchange")
        if(delegate != nil){
            delegate!.chatDidChangeContent()
        }
    }
    
    
}