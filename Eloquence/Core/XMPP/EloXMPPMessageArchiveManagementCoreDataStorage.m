#import "EloXMPPMessageArchiveManagementCoreDataStorage.h"
#import "EloContactListCoreDataStorage.h"

@implementation EloXMPPMessageArchiveManagementCoreDataStorage


- (NSString *)managedObjectModelName
{
    return @"XMPPMessageArchiveManagement";
}


- (void)willInsertContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
    [EloContactListCoreDataStorage.sharedInstance didUpdateOrInsertMamContact:contact];
}

- (void)didUpdateContact:(XMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
    [EloContactListCoreDataStorage.sharedInstance didUpdateOrInsertMamContact:contact];
}

@end
