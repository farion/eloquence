#import "XMPPLogging.h"
#import <XMPPFramework/XMPPCoreDataStorageProtected.h>
#import "EloContactListCoreDataStorage.h"
#import "EloContactList_Item_CoreDataObject.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_INFO; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

#define AssertPrivateQueue() \
NSAssert(dispatch_get_specific(storageQueueTag), @"Private method: MUST run on storageQueue");


@implementation EloContactListCoreDataStorage

static EloContactListCoreDataStorage *sharedInstance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[EloContactListCoreDataStorage alloc] initWithDatabaseFilename: nil storeOptions:nil];
    });
    
    return sharedInstance;
}

/*
- (void)commonInit {
    
    [super commonInit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDataModelChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:[self managedObjectContext]];

    
}

- (void)handleDataModelChange:(NSNotification *)note
{
    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
    
    NSLog(@"called");
}
 */

- (NSEntityDescription *)itemEntity:(NSManagedObjectContext *)moc
{
    return [NSEntityDescription entityForName:@"EloContactList_Item_CoreDataObject" inManagedObjectContext:moc];
}

- (EloContactList_Item_CoreDataObject*) itemForBareJid:(NSString*) itemBareJidStr
                                  managedObjectContext:(NSManagedObjectContext *)moc{
    
    NSEntityDescription *entity = [self itemEntity:moc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@", itemBareJidStr];
    
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
        return (EloContactList_Item_CoreDataObject *)[results lastObject];
    }
}


- (void)didUpdateOrInsertMamContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject*) mamContact {
    
    [self scheduleBlock:^{
        
        BOOL didCreateNewItem = NO;
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        
        EloContactList_Item_CoreDataObject *item = [self itemForBareJid:mamContact.bareJidStr managedObjectContext:moc];
        
        if (item == nil)
        {
            item = (EloContactList_Item_CoreDataObject *)
            [[NSManagedObject alloc] initWithEntity:[self itemEntity:moc]
                     insertIntoManagedObjectContext:nil];
            
            didCreateNewItem = YES;
        }
        
        item.bareJid = mamContact.bareJid;
        item.bareJidStr = mamContact.bareJidStr;
        item.streamBareJidStr = mamContact.streamBareJidStr;;
        
        XMPPLogVerbose(@"New contact list item: %@", item);
        
        if (didCreateNewItem)
        {
            XMPPLogVerbose(@"Inserting contact list item ...");
            
            [moc insertObject:item];
        }
        else
        {
            XMPPLogVerbose(@"Updating contact...");
        }
    }];

}

- (void)didUpdateOrInsertUser:(XMPPUserCoreDataStorageObject*) user {
    [self scheduleBlock:^{
        
        BOOL didCreateNewItem = NO;
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        
        EloContactList_Item_CoreDataObject *item = [self itemForBareJid:user.jidStr managedObjectContext:moc];
        
        if (item == nil)
        {
            item = (EloContactList_Item_CoreDataObject *) [[NSManagedObject alloc] initWithEntity:[self itemEntity:moc]
                                                                   insertIntoManagedObjectContext:nil];
            
            didCreateNewItem = YES;
        }
        
        item.bareJid = user.jid;
        item.bareJidStr = user.jidStr;
        item.streamBareJidStr = user.streamBareJidStr;;
        
        XMPPLogVerbose(@"New contact list item: %@", item);
        
        if (didCreateNewItem)
        {
            XMPPLogVerbose(@"Inserting contact list item ...");
            
            [moc insertObject:item];
        }
        else
        {
            XMPPLogVerbose(@"Updating contact...");
        }
    }];
}


@end
