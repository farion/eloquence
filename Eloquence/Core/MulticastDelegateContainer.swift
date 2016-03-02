//
//   This file is part of Eloquence IM.
//
//   Eloquence is licensed under the Apache License 2.0.
//   See LICENSE file for more information.
//

import Foundation

// Basically taken from
// http://stackoverflow.com/a/33300974

protocol MulticastDelegateContainer {
    
    typealias DelegateType : NSObjectProtocol
    var multicastDelegate  : [DelegateType] {set get}
}

extension MulticastDelegateContainer {
    
    mutating func addDelegate(delegate : DelegateType) {
        multicastDelegate.append(delegate)
    }
    
    mutating func removeDelegate(delegate : DelegateType) {
        guard let indexToRemove = self.multicastDelegate.indexOf({(item : DelegateType) -> Bool in
            return item === delegate
        }) else {return}
        
        multicastDelegate.removeAtIndex(indexToRemove)
    }
    
    func invokeDelegate(invocation: (DelegateType) -> ()) {
        for delegate in multicastDelegate {
            invocation(delegate)
        }
    }
}