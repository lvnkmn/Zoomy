import Foundation

public protocol ConfigurableUsingClosure {}

public extension ConfigurableUsingClosure {
    
    func configured(usingClosure closure: (inout Self)->()) -> Self {
        var mutableSelf = self
        closure(&mutableSelf)
        return mutableSelf
    }
}


