#import <XMPPFramework/XMPPFramework.h>
#import <XMPPFramework/XMPPCoreDataStorage.h>
#import <XMPPFramework/XMPPUserCoreDataStorageObject.h>
#import "XMPPMessageArchiveManagement_Contact_CoreDataObject.h"

@interface EloContactListCoreDataStorage : XMPPCoreDataStorage

+ (instancetype)sharedInstance;

- (void)didUpdateOrInsertMamContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject*) mamContact;
- (void)didUpdateOrInsertUser:(XMPPUserCoreDataStorageObject*) user;

@end
