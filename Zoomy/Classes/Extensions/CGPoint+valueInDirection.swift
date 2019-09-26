import UIKit

internal extension CGPoint {
    func value(in direction: Side) -> CGFloat {
        switch direction {
        case .top:
            return abs(min(y, 0))
        case .left:
            return abs(min(x, 0))
        case .right:
            return max(x, 0)
        case .bottom:
            return max(y, 0)
        }
    }
}
