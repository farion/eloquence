#import "EloXMPPRosterCoreDataStorage.h"
#import <XMPPFramework/XMPPCoreDataStorageProtected.h>
#import <XMPPFramework/XMPPLogging.h>
#import <XMPPFramework/NSNumber+XMPP.h>

#import "EloContactListCoreDataStorage.h"

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


@implementation EloXMPPRosterCoreDataStorage

static EloXMPPRosterCoreDataStorage *sharedInstance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[EloXMPPRosterCoreDataStorage alloc] initWithDatabaseFilename:nil storeOptions:nil];
    });
    
    return sharedInstance;
}

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
    
    return YES;
}

//TODO also handle presence

- (void)handleRosterItem:(NSXMLElement *)itemSubElement xmppStream:(XMPPStream *)stream
{
    XMPPLogTrace();
    
                        NSLog(@"JOOOOO");
    
    // Remember XML heirarchy memory management rules.
    // The passed parameter is a subnode of the IQ, and we need to pass it to an asynchronous operation.
    NSXMLElement *item = [itemSubElement copy];
    
    [self scheduleBlock:^{
        
        NSManagedObjectContext *moc = [self managedObjectContext];
        
        if ([rosterPopulationSet containsObject:[NSNumber xmpp_numberWithPtr:(__bridge void *)stream]])
        {
            NSString *streamBareJidStr = [[self myJIDForXMPPStream:stream] bare];
            

            
            XMPPUserCoreDataStorageObject* user = [XMPPUserCoreDataStorageObject insertInManagedObjectContext:moc
                                                               withItem:item
                                                       streamBareJidStr:streamBareJidStr];
            
            [EloContactListCoreDataStorage.sharedInstance didUpdateOrInsertUser:user];
            
        }
        else
        {
            NSString *jidStr = [item attributeStringValueForName:@"jid"];
            XMPPJID *jid = [[XMPPJID jidWithString:jidStr] bareJID];
            
            //TODO also add to contact list ??
            
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


@end
