#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

#import <XMPPFramework/XMPPJID.h>

@interface EloContactList_Item_CoreDataObject : NSManagedObject

@property (nonatomic, strong) XMPPJID * bareJid;
@property (nonatomic, strong) NSString * bareJidStr;

@property (nonatomic, strong) NSString * streamBareJidStr;

@end