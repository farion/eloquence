#import <XMPPFramework/XMPP.h>
#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/XMPPResultSet.h>
#import <XMPPFramework/XMPPIDTracker.h>

#import "XMPPMessage+XEP_0313.h"

#define _XMPP_MESSAGE_ARCHIVE_MANAGEMENT_H

@class XMPPIDTracker;

@protocol XMPPMessageArchiveManagementStorage;

/**
 * This class provides support for storing message history.
 * It implements XEP-0313 and a client side history storage.
 * The code is heavly based (was a copy initially) on the XEP-0136 implementation and is still using classes from there.
 * Alltough the XEP-0136 related code was removed.
 */
 
@interface XMPPMessageArchiveManagement : XMPPModule {
    
@protected
    
    __strong id <XMPPMessageArchiveManagementStorage> xmppMessageArchiveManagementStorage;
    XMPPIDTracker *responseTracker;    
    
}

- (void)mamQueryWith: (XMPPJID*) jid andStart: (NSDate*) start andEnd: (NSDate*) end andResultSet: (XMPPResultSet*) resultSet;
- (id)initWithMessageArchiveManagementStorage:(id <XMPPMessageArchiveManagementStorage>)storage;
- (id)initWithMessageArchiveManagementStorage:(id <XMPPMessageArchiveManagementStorage>)storage dispatchQueue:(dispatch_queue_t)queue;

@property (readonly, strong) id <XMPPMessageArchiveManagementStorage> xmppMessageArchiveManagementStorage;

/**
 *
 **/
@property (readwrite, copy) NSXMLElement *preferences;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol XMPPMessageArchiveManagementStorage <NSObject>
@required

//
//
// -- PUBLIC METHODS --
//
// There are no public methods required by this protocol.
//
// Each individual roster storage class will provide a proper way to access/enumerate the
// users/resources according to the underlying storage mechanism.
//


//
//
// -- PRIVATE METHODS --
//
// These methods are designed to be used ONLY by the XMPPMessageArchiveManagement class.
//
//

/**
 * Configures the storage class, passing its parent and parent's dispatch queue.
 *
 * This method is called by the init method of the XMPPMessageArchiveManagement class.
 * This method is designed to inform the storage class of its parent
 * and of the dispatch queue the parent will be operating on.
 *
 * The storage class may choose to operate on the same queue as its parent,
 * or it may operate on its own internal dispatch queue.
 *
 * This method should return YES if it was configured properly.
 * If a storage class is designed to be used with a single parent at a time, this method may return NO.
 * The XMPPMessageArchiveManagement class is configured to ignore the passed
 * storage class in its init method if this method returns NO.
 **/
- (BOOL)configureWithParent:(XMPPMessageArchiveManagement *)aParent queue:(dispatch_queue_t)queue;

/**
 *
 **/
- (void)archiveMessage:(XMPPMessage *)message outgoing:(BOOL)isOutgoing xmppStream:(XMPPStream *)stream;

@optional

/**
 * The storage class may optionally persistently store the client preferences.
 **/
- (void)setPreferences:(NSXMLElement *)prefs forUser:(XMPPJID *)bareUserJid;

/**
 * The storage class may optionally persistently store the client preferences.
 * This method is then used to fetch previously known preferences when the client first connects to the xmpp server.
 **/
- (NSXMLElement *)preferencesForUser:(XMPPJID *)bareUserJid;

@end
