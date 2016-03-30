#import <XMPPFramework/XMPPMessage.h>
#import <XMPPFramework/XMPPFramework.h>

@interface XMPPMessage (XEP_0313)

- (NSString *)result;
- (XMPPMessage *) forwardedMessage;
- (NSString *)messageId;

@end
