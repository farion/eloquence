#import <Foundation/Foundation.h>

#import <XMPPFramework/XMPPCoreDataStorage.h>

#import "XMPPMessageArchiveManagement.h"
#import "XMPPMessageArchiveManagement_Message_CoreDataObject.h"
#import "XMPPMessageArchiveManagement_Contact_CoreDataObject.h"


@interface XMPPMessageArchiveManagementCoreDataStorage : XMPPCoreDataStorage <XMPPMessageArchiveManagementStorage>
{
	/* Inherited protected variables from XMPPCoreDataStorage
	
	NSString *databaseFileName;
	NSUInteger saveThreshold;
	
	dispatch_queue_t storageQueue;
	 
	*/
}

/**
 * Convenience method to get an instance with the default database name.
 * 
 * IMPORTANT:
 * You are NOT required to use the sharedInstance.
 * 
 * If your application uses multiple xmppStreams, and you use a sharedInstance of this class,
 * then all of your streams share the same database store. You might get better performance if you create
 * multiple instances of this class instead (using different database filenames), as this way you can have
 * concurrent writes to multiple databases.
**/
+ (instancetype)sharedInstance;


@property (strong) NSString *messageEntityName;
@property (strong) NSString *contactEntityName;

- (NSEntityDescription *)messageEntity:(NSManagedObjectContext *)moc;
- (NSEntityDescription *)contactEntity:(NSManagedObjectContext *)moc;

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactForMessage:(XMPPMessageArchiveManagement_Message_CoreDataObject *)msg;

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactWithJid:(XMPPJID *)contactJid
                                                              streamJid:(XMPPJID *)streamJid
                                                   managedObjectContext:(NSManagedObjectContext *)moc;

- (XMPPMessageArchiveManagement_Contact_CoreDataObject *)contactWithBareJidStr:(NSString *)contactBareJidStr
                                                              streamBareJidStr:(NSString *)streamBareJidStr
                                                          managedObjectContext:(NSManagedObjectContext *)moc;

/* Inherited from XMPPCoreDataStorage
 * Please see the XMPPCoreDataStorage header file for extensive documentation.
 
- (id)initWithDatabaseFilename:(NSString *)databaseFileName storeOptions:(NSDictionary *)storeOptions;
- (id)initWithInMemoryStore;

@property (readonly) NSString *databaseFileName;
 
@property (readwrite) NSUInteger saveThreshold;

@property (readonly) NSManagedObjectModel *managedObjectModel;
@property (readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly) NSManagedObjectContext *mainThreadManagedObjectContext;
 
*/

@end
