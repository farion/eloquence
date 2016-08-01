#import "EloXMPPMessageArchiveManagementWithContactCoreDataStorage.h"
#import "EloContactListCoreDataStorage.h"

@implementation EloXMPPMessageArchiveManagementWithContactCoreDataStorage


- (NSString *)managedObjectModelName
{
    return @"XMPPMessageArchiveManagement";
}


- (void)willInsertContact:(EloXMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
    [EloContactListCoreDataStorage.sharedInstance didUpdateOrInsertMamContact:contact];
}

- (void)didUpdateContact:(EloXMPPMessageArchiveManagement_Contact_CoreDataObject *)contact
{
    [EloContactListCoreDataStorage.sharedInstance didUpdateOrInsertMamContact:contact];
}

@end
