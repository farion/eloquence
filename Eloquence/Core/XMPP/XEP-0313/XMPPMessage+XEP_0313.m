#import "XMPPMessage+XEP_0313.h"

@implementation XMPPMessage (XEP_0313)

- (NSString *)result
{
    return [[self elementForName:@"result" xmlns:@"urn:xmpp:mam:0"] stringValue];
}

- (NSString *)messageId
{
    return [[self attributeForName:@"id"] stringValue];
}

- (XMPPMessage *) forwardedMessage
{
    return [XMPPMessage messageFromElement: [[[self elementForName:@"result" xmlns:@"urn:xmpp:mam:0"] elementForName:@"forwarded" xmlns:@"urn:xmpp:forward:0"] elementForName:@"message" xmlns: @"jabber:client"]];
}

@end