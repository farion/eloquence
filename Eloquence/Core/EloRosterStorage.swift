//
//  EloRosterStorage.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 10.03.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Foundation
import XMPPFramework



class EloRosterStorage:EloXMPPRosterCoreDataStorage, XMPPRosterStorage {

    static let sharedInstance = EloRosterStorage()
    
    var rosterPopulationSet:NSMutableSet?

    override init() {
        super.init(databaseFilename: nil, storeOptions: nil)
    }
    
    //Setup
    
    override func commonInit(){
//        XMPPLogTrace()
        super.commonInit()
    
        // This method is invoked by all public init methods of the superclass
        autoRemovePreviousDatabaseFile = true;
        autoRecreateDatabaseFile = true;
    
        rosterPopulationSet = NSMutableSet()
    }
    
    
    func configureWithParent(aParent: XMPPRoster!, queue: dispatch_queue_t!) -> Bool {
        
    }
    
    /*
    - (BOOL)configureWithParent:(XMPPRoster *)aParent queue:(dispatch_queue_t)queue
    {
    NSParameterAssert(aParent != nil);
    NSParameterAssert(queue != NULL);
    
    @synchronized(self)
    {
    if ((parent == nil) && (parentQueue == NULL))
    {
    parent = aParent;
    parentQueue = queue;
    parentQueueTag = &parentQueueTag;
    dispatch_queue_set_specific(parentQueue, parentQueueTag, parentQueueTag, NULL);
    
    #if !OS_OBJECT_USE_OBJC
    dispatch_retain(parentQueue);
    #endif
    
    return YES;
    }
    }
    
    return NO;
    
    }*/
    
    /*
    - (void)dealloc
    {
    #if !OS_OBJECT_USE_OBJC
    if (parentQueue)
    dispatch_release(parentQueue);
    #endif
    }
    */
    
    //utilities
 
//clearAllResourcesForXMPPStream
        
        
    /*
    - (void)_clearAllResourcesForXMPPStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    AssertPrivateQueue();
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPResourceCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:saveThreshold];
    
    if (stream)
    {
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",
    [[self myJIDForXMPPStream:stream] bare]];
    
    [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allResources = [moc executeFetchRequest:fetchRequest error:nil];
    
    NSUInteger unsavedCount = [self numberOfUnsavedChanges];
    
    for (XMPPResourceCoreDataStorageObject *resource in allResources)
    {
    XMPPUserCoreDataStorageObject *user = resource.user;
    [moc deleteObject:resource];
    [user recalculatePrimaryResource];
    
    if (++unsavedCount >= saveThreshold)
    {
    [self save];
    unsavedCount = 0;
    }
    }
    }
*/
    
    //overrides
    
    
    // This method is overriden from the XMPPCoreDataStore superclass.
    // From the documentation:
    //
    // Override me, if needed, to provide customized behavior.
    //
    // For example, you may want to perform cleanup of any non-persistent data before you start using the database.
    //
    // The default implementation does nothing.
    
    
    // Reserved for future use (directory versioning).
    // Perhaps invoke [self _clearAllResourcesForXMPPStream:nil] ?

    override func didCreateManagedObjectContext() {
        
    }
    
    
    //public api

    func myUserForXMPPStream(stream:XMPPStream) -> XMPPUserCoreDataStorageObject {
        // This is a public method, so it may be invoked on any thread/queue.
        
//        XMPPLogTrace();
        
    }
    
    /*
    
    - (XMPPUserCoreDataStorageObject *)myUserForXMPPStream:(XMPPStream *)stream
    managedObjectContext:(NSManagedObjectContext *)moc
    {

    
    XMPPJID *myJID = stream.myJID;
    if (myJID == nil)
    {
    return nil;
    }
    
    return [self userForJID:myJID xmppStream:stream managedObjectContext:moc];
    }
    
*/

    
    func myResourceForXMPPStream(stream:XMPPStream, managedObjectContext moc:NSManagedObjectContext) -> XMPPResourceCoreDataStorageObject {
        
        // This is a public method, so it may be invoked on any thread/queue.
        
        //        XMPPLogTrace();
        
        
    }
    
    
    /*
    - (XMPPResourceCoreDataStorageObject *)myResourceForXMPPStream:(XMPPStream *)stream
    managedObjectContext:(NSManagedObjectContext *)moc
    {
    
    XMPPJID *myJID = stream.myJID;
    if (myJID == nil)
    {
    return nil;
    }
    
    return [self resourceForJID:myJID xmppStream:stream managedObjectContext:moc];
    }
*/
    
    
    func userForJID(jid:XMPPJID, xmppStream stream:XMPPStream, managedObjectContext moc:NSManagedObjectContext) -> XMPPUserCoreDataStorageObject {
        // This is a public method, so it may be invoked on any thread/queue.
        
        //        XMPPLogTrace();
        
        
    }

    
/*
    - (XMPPUserCoreDataStorageObject *)userForJID:(XMPPJID *)jid
    xmppStream:(XMPPStream *)stream
    managedObjectContext:(NSManagedObjectContext *)moc
    {

    
    if (jid == nil) return nil;
    if (moc == nil) return nil;
    
    NSString *bareJIDStr = [jid bare];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSPredicate *predicate;
    if (stream == nil)
    predicate = [NSPredicate predicateWithFormat:@"jidStr == %@", bareJIDStr];
    else
    predicate = [NSPredicate predicateWithFormat:@"jidStr == %@ AND streamBareJidStr == %@",
    bareJIDStr, [[self myJIDForXMPPStream:stream] bare]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPendingChanges:YES];
    [fetchRequest setFetchLimit:1];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    
    return (XMPPUserCoreDataStorageObject *)[results lastObject];
    }
*/
    
    
    func resourceForJID(jid:XMPPJID, xmppStream stream:XMPPStream, managedObjectContext moc:NSManagedObjectContext) -> XMPPResourceCoreDataStorageObject{
        // This is a public method, so it may be invoked on any thread/queue.
        
        //        XMPPLogTrace();
        
        
    }
    

    /*
    - (XMPPResourceCoreDataStorageObject *)resourceForJID:(XMPPJID *)jid
    xmppStream:(XMPPStream *)stream
    managedObjectContext:(NSManagedObjectContext *)moc
    {

    
    if (jid == nil) return nil;
    if (moc == nil) return nil;
    
    NSString *fullJIDStr = [jid full];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPResourceCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSPredicate *predicate;
    if (stream == nil)
    predicate = [NSPredicate predicateWithFormat:@"jidStr == %@", fullJIDStr];
    else
    predicate = [NSPredicate predicateWithFormat:@"jidStr == %@ AND streamBareJidStr == %@",
    fullJIDStr, [[self myJIDForXMPPStream:stream] bare]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setIncludesPendingChanges:YES];
    [fetchRequest setFetchLimit:1];
    
    NSArray *results = [moc executeFetchRequest:fetchRequest error:nil];
    
    return (XMPPResourceCoreDataStorageObject *)[results lastObject];
    }
*/
  
    //private api
    
    
    func beginRosterPopulationForXMPPStream(stream: XMPPStream!, withVersion version: String!) {
        self.scheduleBlock({})
    }
    
    /*
    - (void)beginRosterPopulationForXMPPStream:(XMPPStream *)stream withVersion:(NSString *)version
    {
    XMPPLogTrace();
    
    [self scheduleBlock:^{
    
    [rosterPopulationSet addObject:[NSNumber xmpp_numberWithPtr:(__bridge void *)stream]];
    
    // Clear anything already in the roster core data store.
    //
    // Note: Deleting a user will delete all associated resources
    // because of the cascade rule in our core data model.
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:saveThreshold];
    
    if (stream)
    {
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",
    [[self myJIDForXMPPStream:stream] bare]];
    
    [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allUsers = [moc executeFetchRequest:fetchRequest error:nil];
    
    for (XMPPUserCoreDataStorageObject *user in allUsers)
    {
    [moc deleteObject:user];
    }
    
    [XMPPGroupCoreDataStorageObject clearEmptyGroupsInManagedObjectContext:moc];
    }];
    }
*/

    func endRosterPopulationForXMPPStream(stream: XMPPStream!) {
        self.scheduleBlock( {})
    }

    /*
    - (void)endRosterPopulationForXMPPStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    [self scheduleBlock:^{
    
    [rosterPopulationSet removeObject:[NSNumber xmpp_numberWithPtr:(__bridge void *)stream]];
    }];
    }
    */
    
    func handleRosterItem(item: DDXMLElement!, xmppStream stream: XMPPStream!) {
    

    }
    
    /*
    - (void)handleRosterItem:(NSXMLElement *)itemSubElement xmppStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    // Remember XML heirarchy memory management rules.
    // The passed parameter is a subnode of the IQ, and we need to pass it to an asynchronous operation.
    NSXMLElement *item = [itemSubElement copy];
    
    [self scheduleBlock:^{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    if ([rosterPopulationSet containsObject:[NSNumber xmpp_numberWithPtr:(__bridge void *)stream]])
    {
    NSString *streamBareJidStr = [[self myJIDForXMPPStream:stream] bare];
    
    [XMPPUserCoreDataStorageObject insertInManagedObjectContext:moc
    withItem:item
    streamBareJidStr:streamBareJidStr];
    }
    else
    {
    NSString *jidStr = [item attributeStringValueForName:@"jid"];
    XMPPJID *jid = [[XMPPJID jidWithString:jidStr] bareJID];
    
    XMPPUserCoreDataStorageObject *user = [self userForJID:jid xmppStream:stream managedObjectContext:moc];
    
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"remove"])
    {
				if (user)
				{
    [moc deleteObject:user];
				}
    }
    else
    {
				if (user)
				{
    [user updateWithItem:item];
				}
				else
				{
    NSString *streamBareJidStr = [[self myJIDForXMPPStream:stream] bare];
    
    [XMPPUserCoreDataStorageObject insertInManagedObjectContext:moc
    withItem:item
    streamBareJidStr:streamBareJidStr];
				}
    }
    }
    }];
    }
*/

    func handlePresence(presence: XMPPPresence!, xmppStream stream: XMPPStream!) {
        
    }
    
    /*
    - (void)handlePresence:(XMPPPresence *)presence xmppStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    BOOL allowRosterlessOperation = [parent allowRosterlessOperation];
    
    [self scheduleBlock:^{
    
    XMPPJID *jid = [presence from];
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSString *streamBareJidStr = [[self myJIDForXMPPStream:stream] bare];
    
    XMPPUserCoreDataStorageObject *user = [self userForJID:jid xmppStream:stream managedObjectContext:moc];
    
    if (user == nil && allowRosterlessOperation)
    {
    // This may happen if the roster is in rosterlessOperation mode.
    
    user = [XMPPUserCoreDataStorageObject insertInManagedObjectContext:moc
    withJID:[presence from]
    streamBareJidStr:streamBareJidStr];
    }
    
    [user updateWithPresence:presence streamBareJidStr:streamBareJidStr];
    }];
    }
*/
    func userExistsWithJID(jid: XMPPJID!, xmppStream stream: XMPPStream!) -> Bool {
        
    }
    
    
    /*
    
    - (BOOL)userExistsWithJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    __block BOOL result = NO;
    
    [self executeBlock:^{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    XMPPUserCoreDataStorageObject *user = [self userForJID:jid xmppStream:stream managedObjectContext:moc];
    
    result = (user != nil);
    }];
    
    return result;
    }
    
    #if TARGET_OS_IPHONE
    - (void)setPhoto:(UIImage *)photo forUserWithJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream
    #else
    - (void)setPhoto:(NSImage *)photo forUserWithJID:(XMPPJID *)jid xmppStream:(XMPPStream *)stream
    #endif
    {
    XMPPLogTrace();
    
    [self scheduleBlock:^{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    XMPPUserCoreDataStorageObject *user = [self userForJID:jid xmppStream:stream managedObjectContext:moc];
    
    if (user)
    {
    user.photo = photo;
    }
    }];
    }
*/

    func clearAllResourcesForXMPPStream(stream: XMPPStream!) {
        
    }
    
    /*
    - (void)clearAllResourcesForXMPPStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    [self scheduleBlock:^{
    
    [self _clearAllResourcesForXMPPStream:stream];
    }];
    }
*/
    func clearAllUsersAndResourcesForXMPPStream(stream: XMPPStream!) {
        
    }    /*

    - (void)clearAllUsersAndResourcesForXMPPStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    [self scheduleBlock:^{
    
    // Note: Deleting a user will delete all associated resources
    // because of the cascade rule in our core data model.
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:saveThreshold];
    
    if (stream)
    {
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",
    [[self myJIDForXMPPStream:stream] bare]];
    
    [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allUsers = [moc executeFetchRequest:fetchRequest error:nil];
    
    NSUInteger unsavedCount = [self numberOfUnsavedChanges];
    
    for (XMPPUserCoreDataStorageObject *user in allUsers)
    {
    [moc deleteObject:user];
    
    if (++unsavedCount >= saveThreshold)
    {
				[self save];
				unsavedCount = 0;
    }
    }
    
    [XMPPGroupCoreDataStorageObject clearEmptyGroupsInManagedObjectContext:moc];
    }];
    }
*/
    
    func jidsForXMPPStream(stream: XMPPStream!) -> [AnyObject]! {
    
    }
    
    
    /*
    - (NSArray *)jidsForXMPPStream:(XMPPStream *)stream{
    
    XMPPLogTrace();
    
    __block NSMutableArray *results = [NSMutableArray array];
    
    [self executeBlock:^{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
    inManagedObjectContext:moc];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:saveThreshold];
    
    if (stream)
    {
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr == %@",
    [[self myJIDForXMPPStream:stream] bare]];
    
    [fetchRequest setPredicate:predicate];
    }
    
    NSArray *allUsers = [moc executeFetchRequest:fetchRequest error:nil];
    
    for(XMPPUserCoreDataStorageObject *user in allUsers){
    [results addObject:[user.jid bareJID]];
    }
    
    }];
    
    return results;
    }
*/
    
    func getSubscription(subscription: AutoreleasingUnsafeMutablePointer<NSString?>, ask: AutoreleasingUnsafeMutablePointer<NSString?>, nickname: AutoreleasingUnsafeMutablePointer<NSString?>, groups: AutoreleasingUnsafeMutablePointer<NSArray?>, forJID jid: XMPPJID!, xmppStream stream: XMPPStream!) {

    }
    
    /*
    - (void)getSubscription:(NSString **)subscription
    ask:(NSString **)ask
    nickname:(NSString **)nickname
    groups:(NSArray **)groups
    forJID:(XMPPJID *)jid
    xmppStream:(XMPPStream *)stream
    {
    XMPPLogTrace();
    
    [self executeBlock:^{
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    XMPPUserCoreDataStorageObject *user = [self userForJID:jid xmppStream:stream managedObjectContext:moc];
    
    if(user)
    {
    if(subscription)
    {
    *subscription = user.subscription;
    }
    
    if(ask)
    {
    *ask = user.ask;
    }
    
    if(nickname)
    {
    *nickname = user.nickname;
    }
    
    if(groups)
    {
    if([user.groups count])
    {
    NSMutableArray *groupNames = [NSMutableArray array];
    
    for(XMPPGroupCoreDataStorageObject *group in user.groups){
    [groupNames addObject:group.name];
    }
    
    *groups = groupNames;
    }
    }
    }
    }];
*/
    
    @objc func setPhoto(image: UIImage!, forUserWithJID jid: XMPPJID!, xmppStream stream: XMPPStream!) {
        
    }
    
}