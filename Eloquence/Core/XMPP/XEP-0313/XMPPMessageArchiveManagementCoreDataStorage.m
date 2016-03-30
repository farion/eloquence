#import <XMPPFramework/XMPPCoreDataStorageProtected.h>
#import <XMPPFramework/XMPPLogging.h>
#import <XMPPFramework/NSXMLElement+XEP_0203.h>
#import <XMPPFramework/XMPPMessage+XEP_0085.h>

#import "XMPPMessageArchiveManagementCoreDataStorage.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
  static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // VERBOSE; // | XMPP_LOG_FLAG_TRACE;
#else
  static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

@interface XMPPMessageArchiveManagementCoreDataStorage ()
{
	NSString *messageEntityName;
	NSString *contactEntityName;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation XMPPMessageArchiveManagementCoreDataStorage

static XMPPMessageArchiveManagementCoreDataStorage *sharedInstance;

+ (instancetype)sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		sharedInstance = [[XMPPMessageArchiveManagementCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
	});
	
	return sharedInstance;
}

/**
 * Documentation from the superclass (XMPPCoreDataStorage):
 * 
 * If your subclass needs to do anything for init, it can do so easily by overriding this method.
 * All public init methods will invoke this method at the end of their implementation.
 * 
 * Important: If overriden you must invoke [super commonInit] at some point.
**/
- (void)commonInit
{
	[super commonInit];
	
	messageEntityName = @"XMPPMessageArchiveManagement_Message_CoreDataObject";
	contactEntityName = @"XMPPMessageArchiveManagement_Contact_CoreDataObject";
}

/**
 * Documentation from the superclass (XMPPCoreDataStorage):
 * 
 * Override me, if needed, to provide customized behavior.
 * For example, you may want to perform cleanup of any non-persistent data before you start using the database.
 * 
 * The default implementation does nothing.
**/
- (void)didCreateManagedObjectContext
{
	// If there are any "composing" messages in the database, delete them (as they are temporary).
	
	NSManagedObjectContext *moc = [self managedObjectContext];
	NSEntityDescription *messageEntity = [self messageEntity:moc];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"composing == YES"];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = messageEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.fetchBatchSize = saveThreshold;
	
	NSError *error = nil;
	NSArray *messages = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (messages == nil)
	{
		XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", [self class], THIS_METHOD, error);
		return;
	}
	
	NSUInteger count = 0;
	
	for (XMPPMessageArchiveManagement_Message_CoreDataObject *message in messages)
	{
		[moc deleteObject:message];
		
		if (++count > saveThreshold)
		{
			if (![moc save:&error])
			{
				XMPPLogWarn(@"%@: Error saving - %@ %@", [self class], error, [error userInfo]);
				[moc rollback];
			}
		}
	}
	
	if (count > 0)
	{
		if (![moc save:&error])
		{
			XMPPLogWarn(@"%@: Error saving - %@ %@", [self class], error, [error userInfo]);
			[moc rollback];
		}
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Internal API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)willInsertMessage:(XMPPMessageArchiveManagement_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)didUpdateMessage:(XMPPMessageArchiveManagement_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)willDeleteMessage:(XMPPMessageArchiveManagement_Message_CoreDataObject *)message
{
	// Override hook
}

- (void)willInsertContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
	// Override hook
}

- (void)didUpdateContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
	// Override hook
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (XMPPMessageArchiveManagement_Message_CoreDataObject *)composingMessageWithJid:(XMPPJID *)messageJid
                                                                       streamJid:(XMPPJID *)streamJid
                                                                        outgoing:(BOOL)isOutgoing
                                                            managedObjectContext:(NSManagedObjectContext *)moc
{
	XMPPMessageArchiveManagement_Message_CoreDataObject *result = nil;
	
	NSEntityDescription *messageEntity = [self messageEntity:moc];
	
	// Order matters:
	// 1. composing - most likely not many with it set to YES in database
	// 2. bareJidStr - splits database by number of conversations
	// 3. outgoing - splits database in half
	// 4. streamBareJidStr - might not limit database at all
	
	NSString *predicateFrmt = @"composing == YES AND bareJidStr == %@ AND outgoing == %@ AND streamBareJidStr == %@";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFrmt,
                                                            [messageJid bare], @(isOutgoing),
                                                            [streamJid bare]];
	
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	fetchRequest.entity = messageEntity;
	fetchRequest.predicate = predicate;
	fetchRequest.sortDescriptors = @[sortDescriptor];
	fetchRequest.fetchLimit = 1;
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil || error)
	{
		XMPPLogError(@"%@: %@ - Error executing fetchRequest: %@", THIS_FILE, THIS_METHOD, fetchRequest);
	}
	else
	{
		result = (XMPPMessageArchiveManagement_Message_CoreDataObject *)[results lastObject];
	}
	
	return result;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Public API
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactForMessage:(XMPPMessageArchiveManagement_Message_CoreDataObject *)msg
{
	// Potential override hook
	
	return [self contactWithBareJidStr:msg.bareJidStr
	                  streamBareJidStr:msg.streamBareJidStr
	              managedObjectContext:msg.managedObjectContext];
}

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactWithJid:(XMPPJID *)contactJid
                                                              streamJid:(XMPPJID *)streamJid
                                                   managedObjectContext:(NSManagedObjectContext *)moc
{
	return [self contactWithBareJidStr:[contactJid bare]
	                  streamBareJidStr:[streamJid bare]
	              managedObjectContext:moc];
}

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactWithBareJidStr:(NSString *)contactBareJidStr
                                                              streamBareJidStr:(NSString *)streamBareJidStr
                                                          managedObjectContext:(NSManagedObjectContext *)moc
{
	NSEntityDescription *entity = [self contactEntity:moc];
	
	NSPredicate *predicate;
	if (streamBareJidStr)
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@ AND streamBareJidStr == %@",
	                                                              contactBareJidStr, streamBareJidStr];
	}
	else
	{
		predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", contactBareJidStr];
	}
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entity];
	[fetchRequest setFetchLimit:1];
	[fetchRequest setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
	
	if (results == nil)
	{
		XMPPLogError(@"%@: %@ - Fetch request error: %@", THIS_FILE, THIS_METHOD, error);
		return nil;
	}
	else
	{
		return (XMPPMessageArchiveManagement_Contact_CoreDataObject *)[results lastObject];
	}
}

- (NSString *)messageEntityName
{
	__block NSString *result = nil;
	
	dispatch_block_t block = ^{
		result = messageEntityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_sync(storageQueue, block);
	
	return result;
}

- (void)setMessageEntityName:(NSString *)entityName
{
	dispatch_block_t block = ^{
		messageEntityName = entityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_async(storageQueue, block);
}

- (NSString *)contactEntityName
{
	__block NSString *result = nil;
	
	dispatch_block_t block = ^{
		result = contactEntityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_sync(storageQueue, block);
	
	return result;
}

- (void)setContactEntityName:(NSString *)entityName
{
	dispatch_block_t block = ^{
		contactEntityName = entityName;
	};
	
	if (dispatch_get_specific(storageQueueTag))
		block();
	else
		dispatch_async(storageQueue, block);
}

- (NSEntityDescription *)messageEntity:(NSManagedObjectContext *)moc
{
	// This is a public method, and may be invoked on any queue.
	// So be sure to go through the public accessor for the entity name.
	
	return [NSEntityDescription entityForName:[self messageEntityName] inManagedObjectContext:moc];
}

- (NSEntityDescription *)contactEntity:(NSManagedObjectContext *)moc
{
	// This is a public method, and may be invoked on any queue.
	// So be sure to go through the public accessor for the entity name.
	
	return [NSEntityDescription entityForName:[self contactEntityName] inManagedObjectContext:moc];
}

- (XMPPMessageArchiveManagement_Message_CoreDataObject* )getMessageByMessageId:(NSString *)messageId
{

    if(messageId == nil){
        return nil;
    }
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entity = [self messageEntity:moc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"messageId == %@", messageId];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];
    [fetchRequest setPredicate:predicate];


    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    //TODO error handling
    
    if ([results count] == 0){
        return nil;
    }
    
    return results[0];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Storage Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)configureWithParent:(XMPPMessageArchiveManagement *)aParent queue:(dispatch_queue_t)queue
{
	return [super configureWithParent:aParent queue:queue];
}

- (void)archiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing xmppStream:(XMPPStream *)xmppStream
{
	// Message should either have a body, or be a composing notification
	
	NSString *messageBody = [[message elementForName:@"body"] stringValue];
	BOOL isComposing = NO;
	BOOL shouldDeleteComposingMessage = NO;
	
	if ([messageBody length] == 0)
	{
		// Message doesn't have a body.
		// Check to see if it has a chat state (composing, paused, etc).
		
		isComposing = [message hasComposingChatState];
		if (!isComposing)
		{
			if ([message hasChatState])
			{
				// Message has non-composing chat state.
				// So if there is a current composing message in the database,
				// then we need to delete it.
				shouldDeleteComposingMessage = YES;
			}
			else
			{
				// Message has no body and no chat state.
				// Nothing to do with it.
				return;
			}
		}
	}
	
	[self scheduleBlock:^{
		
		NSManagedObjectContext *moc = [self managedObjectContext];
		XMPPJID *myJid = [self myJIDForXMPPStream:xmppStream];
		
		XMPPJID *messageJid = isOutgoing ? [message to] : [message from];
		
		// Fetch-n-Update OR Insert new message
		
        XMPPMessageArchiveManagement_Message_CoreDataObject *archivedMessage =
		    [self composingMessageWithJid:messageJid
		                        streamJid:myJid
		                         outgoing:isOutgoing
		             managedObjectContext:moc];
		
		if (shouldDeleteComposingMessage)
		{
			if (archivedMessage)
			{
				[self willDeleteMessage:archivedMessage]; // Override hook
				[moc deleteObject:archivedMessage];
			}
			else
			{
				// Composing message has already been deleted (or never existed)
			}
		}
		else
		{
			XMPPLogVerbose(@"Previous archivedMessage: %@", archivedMessage);
			
			BOOL didCreateNewArchivedMessage = NO;
            
            // Message with messageIds are from server
            XMPPMessageArchiveManagement_Message_CoreDataObject *archivedMessageWithSameId =
                [self getMessageByMessageId: [message messageId]];
            
            // No need to archive archived messages twice
            if(archivedMessageWithSameId != nil) {
                return;
            }
            
            if (archivedMessage == nil)
			{
				archivedMessage = (XMPPMessageArchiveManagement_Message_CoreDataObject *)
					[[NSManagedObject alloc] initWithEntity:[self messageEntity:moc]
				             insertIntoManagedObjectContext:nil];
				
				didCreateNewArchivedMessage = YES;
			}
			
			archivedMessage.message = message;
			archivedMessage.body = messageBody;
			
			archivedMessage.bareJid = [messageJid bareJID];
			archivedMessage.streamBareJidStr = [myJid bare];
			
			NSDate *timestamp = [message delayedDeliveryDate];
			if (timestamp)
				archivedMessage.timestamp = timestamp;
			else
				archivedMessage.timestamp = [[NSDate alloc] init];
			
			archivedMessage.thread = [[message elementForName:@"thread"] stringValue];
			archivedMessage.isOutgoing = isOutgoing;
			archivedMessage.isComposing = isComposing;
			
			XMPPLogVerbose(@"New archivedMessage: %@", archivedMessage);
														 
			if (didCreateNewArchivedMessage) // [archivedMessage isInserted] doesn't seem to work
			{
				XMPPLogVerbose(@"Inserting message...");
				
				[archivedMessage willInsertObject];       // Override hook
				[self willInsertMessage:archivedMessage]; // Override hook
				[moc insertObject:archivedMessage];
			}
			else
			{
				XMPPLogVerbose(@"Updating message...");
				
				[archivedMessage didUpdateObject];       // Override hook
				[self didUpdateMessage:archivedMessage]; // Override hook
			}
			
			
            // No need to update contacts for messages from archive.
            if([message messageId] == nil){
                return;
            }
            
            // Create or update contact (if message with actual content)
            
			if ([messageBody length] > 0)
			{
				BOOL didCreateNewContact = NO;
				
				XMPPMessageArchiveManagement_Contact_CoreDataObject *contact = [self contactForMessage:archivedMessage];
				XMPPLogVerbose(@"Previous contact: %@", contact);
				
				if (contact == nil)
				{
					contact = (XMPPMessageArchiveManagement_Contact_CoreDataObject *)
					    [[NSManagedObject alloc] initWithEntity:[self contactEntity:moc]
					             insertIntoManagedObjectContext:nil];
					
					didCreateNewContact = YES;
				}
				
				contact.streamBareJidStr = archivedMessage.streamBareJidStr;
				contact.bareJid = archivedMessage.bareJid;
					
				contact.mostRecentMessageTimestamp = archivedMessage.timestamp;
				contact.mostRecentMessageBody = archivedMessage.body;
				contact.mostRecentMessageOutgoing = @(isOutgoing);
				
				XMPPLogVerbose(@"New contact: %@", contact);
				
				if (didCreateNewContact) // [contact isInserted] doesn't seem to work
				{
					XMPPLogVerbose(@"Inserting contact...");
					
					[contact willInsertObject];       // Override hook
					[self willInsertContact:contact]; // Override hook
					[moc insertObject:contact];
				}
				else
				{
					XMPPLogVerbose(@"Updating contact...");
					
					[contact didUpdateObject];       // Override hook
					[self didUpdateContact:contact]; // Override hook
				}
			}
		}
	}];
}

@end
