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
            XMPPLogError(@"%@: %@ - Unable to configure storage!", THIS_FILE, THIS_METHOD);
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

        //TODO increment
//        [query addAttributeWithName:@"queryid" stringValue: queryId];
    
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
    
        [iq addChild:query];
    
        if(resultSet != nil){
            [iq addChild: resultSet];
        }

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
     Maybe some kind of error hanling? 
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

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    
    [xmppMessageArchiveManagementStorage archiveMessage:message outgoing:YES xmppStream:sender];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    XMPPLogTrace();
    
    if([message forwardedMessage] != nil){
        [xmppMessageArchiveManagementStorage archiveMessage: [message forwardedMessage] outgoing:NO xmppStream:sender];
    }else{
        [xmppMessageArchiveManagementStorage archiveMessage: message outgoing:NO xmppStream:sender];
    }
    
}

@end

