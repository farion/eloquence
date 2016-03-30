import Foundation
import XMPPFramework

protocol EloChatDelegate {
    func didReceiveMessage(msg: EloMessage);
    func didFailSendMessage(msg: EloMessage);
}

enum EloChatError:ErrorType {
  case NotConnected
}

class EloChat:XMPPStreamDelegate {
    
    var delegate: EloChatDelegate?
    
    let from:EloAccountJid
    let to:EloContactJid
    let xmppStream:XMPPStream
    
    init(from: EloAccountJid, to: EloContactJid){
        self.from = from
        self.to = to
        
        xmppStream = EloConnections.sharedInstance.getXMPPStream(from)
        xmppStream.addDelegate(self, delegateQueue: GlobalUserInteractiveQueue)
    }
    
    private func getXMPPStream() throws -> XMPPStream {
        
        if(xmppStream.isConnected()){
                return xmppStream
        }
        
        throw EloChatError.NotConnected
    }
    
    func sendTextMessage(text: String) {
        
        let msg = XMPPMessage(type: "chat", to: to.xmppJid );
        msg.addBody(text);
        
        do {
            let xmppStream = try getXMPPStream();
            xmppStream.sendElement(msg);
        } catch {
            if(delegate != nil){
                delegate!.didFailSendMessage(EloMessage())
            }
        }
    }
    
    func numberOfRows() -> Int{
        return 10; //TODO
    }
    
    func getMessage(index:NSInteger) -> EloMessage{
        let message = EloMessage();
        message.text = "foo"
        return message; //TODO
    }
    
    @objc func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {

        if(message.from().bare() == to.jid){
            if(delegate != nil){
                if(message.isChatMessageWithBody()){
                    let msg = EloMessage();
                    msg.author = to.jid;
                    msg.text = to.jid + ": " + message.body();
                    delegate!.didReceiveMessage(msg);
                }
            }
        }
    }
}