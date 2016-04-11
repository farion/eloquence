#import <XMPPFramework/XMPPLogging.h>
#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/NSDate+XMPPDateTimeProfiles.h>
#import <XMPPFramework/NSNumber+XMPP.h>

#import "XMPPMessageArchiveManagement.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

// Log levels: off, error, warn, info, verbose
// Log flags: trace
#if DEBUG
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN; // | XMPP_LOG_FLAG_TRACE;
#else
static const int xmppLogLevel = XMPP_LOG_LEVEL_WARN;
#endif

//TODO support other versions too
#define XMLNS_XMPP_MAM @"urn:xmpp:mam:0"
#define XMLNS_XMPP_MAM_FORM @"jabber:x:data"


@implementation XMPPMessageArchiveManagement

static dispatch_queue_t queue;
static int queryId = 0;

- (id)init
{
    // This will cause a crash - it's designed to.
    // Only the init methods listed in XMPPMessageArchiveManagement are supported.
    
    return [self initWithMessageArchiveManagementStorage:nil dispatchQueue:NULL];
}

- (id)initWithDispatchQueue:(dispatch_queue_t)queue
{
    // This will cause a crash - it's designed to.
    // Only the init methods listed in XMPPMessageArchiveManagement.h are supported.
    
    return [self initWithMessageArchiveManagementStorage:nil dispatchQueue:queue];
}

- (id)initWithMessageArchiveManagementStorage:(id <XMPPMessageArchiveManagementStorage>)storage
{
    return [self initWithMessageArchiveManagementStorage:storage dispatchQueue:NULL];
}

- (id)initWithMessageArchiveManagementStorage:(id <XMPPMessageArchiveManagementStorage>)storage dispatchQueue:(dispatch_queue_t)queue
{
    NSParameterAssert(storage != nil);
    
    if ((self = [super initWithDispatchQueue:queue]))
    {
        if ([storage configureWithParent:self queue:moduleQueue])
        {
            xmppMessageArchiveManagementStorage = storage;
        }
        else
        {
            XMPPLogError(@"%@: %@ - Unable to configure storageb!", THIS_FILE, THIS_METHOD);
        }
    }
    return self;
}

- (BOOL)activate:(XMPPStream *)aXmppStream
{
    XMPPLogTrace();
    
    if ([super activate:aXmppStream])
    {
        XMPPLogVerbose(@"%@: Activated", THIS_FILE);
        
        responseTracker = [[XMPPIDTracker alloc] initWithDispatchQueue:moduleQueue];
        
        return YES;
    }
    
    return NO;
}

- (void)deactivate
{
    XMPPLogTrace();
    
    dispatch_block_t block = ^{ @autoreleasepool {
        
        [responseTracker removeAllIDs];
        responseTracker = nil;
        
    }};
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_sync(moduleQueue, block);
    
    [super deactivate];
}

- (NSString*) getNextQueryId {
    
    //TODO: is that a reliable way to synchronize the access to queryId globally?
    
    static dispatch_once_t queueCreationGuard;

    dispatch_once(&queueCreationGuard, ^{
        queue = dispatch_queue_create("xmppframework.xep0313.queryIdQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    
    __block int nextQueryId;
    
    dispatch_sync(queue, ^{
        nextQueryId = queryId;
        queryId++;
    });
    
    return [NSString stringWithFormat:@"q%d",nextQueryId];
}

- (NSXMLElement*)getFormField:(NSString*) var withValue:(NSString*) value {
    
    NSXMLElement *fieldEl = [NSXMLElement elementWithName:@"field"];
    [fieldEl addAttributeWithName:@"var" stringValue: var];
    NSXMLElement *valueEl = [NSXMLElement elementWithName:@"value" stringValue: value];
    [fieldEl addChild:valueEl];
    return fieldEl;
}


- (void)mamQueryWith: (XMPPJID*) jid andStart: (NSDate*) start andEnd: (NSDate*) end andResultSet: (XMPPResultSet*) resultSet{
    
    dispatch_block_t block = ^{ @autoreleasepool {
    
        NSLog(@"MAM QUERY");
    
        NSString *elementID = [XMPPStream generateUUID];
    
        XMPPIQ *iq = [XMPPIQ iqWithType:@"set" elementID:elementID];
    //    [iq setXmlns:@"jabber:client"];
    
        NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:XMLNS_XMPP_MAM];

        [query addAttributeWithName:@"queryid" stringValue: [self getNextQueryId]];
    
        if(jid != nil || start != nil || end != nil) {
            NSXMLElement *filterForm = [NSXMLElement elementWithName:@"x" xmlns:XMLNS_XMPP_MAM_FORM];
            [filterForm addAttributeWithName:@"type" stringValue:@"submit"];
        
            NSXMLElement *fieldFormType = [self getFormField: @"FORM_TYPE" withValue: XMLNS_XMPP_MAM ];
            [fieldFormType addAttributeWithName:@"type" stringValue:@"hidden"];
        
            [filterForm addChild:fieldFormType];
        
            if(jid != nil){
                NSXMLElement *fieldJid = [self getFormField:@"with" withValue: jid.bare];
                [filterForm addChild:fieldJid];
            }
        
            if(start != nil){
                NSXMLElement *fieldStart = [self getFormField:@"start" withValue: start.xmppDateTimeString];
                [filterForm addChild:fieldStart];
            }
        
            if(end != nil){
                NSXMLElement *fieldEnd = [self getFormField:@"end" withValue: end.xmppDateTimeString];
                [filterForm addChild:fieldEnd];
            }
        
            [query addChild:filterForm];
        }

        if(resultSet != nil){
            [query addChild: resultSet];
        }
        
        [iq addChild:query];
    
        [xmppStream sendElement:iq];
            
        [responseTracker addElement:iq
                             target:self
                           selector:@selector(returnQuery:withInfo:)
                            timeout:XMPPIDTrackerTimeoutNone];

    }};
    
    if (dispatch_get_specific(moduleQueueTag))
        block();
    else
        dispatch_async(moduleQueue, block);
    
}

- (void)returnQuery:(XMPPIQ *)iq withInfo:(XMPPBasicTrackingInfo *)trackerInfo {
    
    /*
     Basically this happens once per query and does not contain any additional information.
     Maybe some kind of error handling?
     TODO
     */
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Properties
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id <XMPPMessageArchiveManagementStorage>)xmppMessageArchiveManagementStorage
{
    // Note: The xmppMessageArchiveManagementStorage variable is read-only (set in the init method)
    
    return xmppMessageArchiveManagementStorage;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    XMPPLogTrace();
    
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //TODO
    //handle paging
    NSLog(@"IQQQQ");
    return YES;
}

- (void)insertMessageIntoStorage:(XMPPStream *)sender message:(XMPPMessage *)message {
    
    BOOL outgoing = [message.from.bare isEqualToString: sender.myJID.bare];
    [xmppMessageArchiveManagementStorage archiveMessage: message outgoing:outgoing xmppStream:sender];
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    
    [self insertMessageIntoStorage:sender message:message];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    
    XMPPMessage* forwardedMessage = [message forwardedMessage];
    
    if(forwardedMessage != nil){
        [self insertMessageIntoStorage:sender message:forwardedMessage];
    }else{
        [self insertMessageIntoStorage:sender message:message];
    }
    
}

@end

