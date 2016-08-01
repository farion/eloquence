#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/XMPPCoreDataStorage.h>
#import <XMPPFramework/XMPPUserCoreDataStorageObject.h>
#import "EloXMPPMessageArchiveManagement_Contact_CoreDataObject.h"

@interface EloContactListCoreDataStorage : XMPPCoreDataStorage

+ (instancetype)sharedInstance;

- (void)didUpdateOrInsertMamContact:(EloXMPPMessageArchiveManagement_Contact_CoreDataObject*) mamContact;
- (void)didUpdateOrInsertUser:(XMPPUserCoreDataStorageObject*) user;

@end
