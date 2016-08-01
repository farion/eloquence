#import "XMPPMessage+Elo_XEP_0313.h"

@implementation XMPPMessage (Elo_XEP_0313)

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
    //TODO support mam:tmp and mam:1
    NSXMLElement* forwardedElement = [[self elementForName:@"result" xmlns:@"urn:xmpp:mam:0"] elementForName:@"forwarded" xmlns:@"urn:xmpp:forward:0"];
    
    NSXMLElement* messageElement = [forwardedElement elementForName:@"message" xmlns: @"jabber:client"];
    
    //XEP-0313 adds a delay element outside message instead inside.
    //So we "fix" the element to work as expected internally.
    
    NSXMLElement* delayElement = [forwardedElement elementForName:@"delay" xmlns: @"urn:xmpp:delay"];
    
    [messageElement removeElementForName:@"delay"]; //sometimes server sends additional delay. Noticed on ejabberd.
    [messageElement addChild: [delayElement copy]];
    
    return [XMPPMessage messageFromElement: messageElement];
}

@end