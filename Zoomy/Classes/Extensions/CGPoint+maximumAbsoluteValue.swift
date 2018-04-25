import Foundation

internal extension CGPoint {
    var maxAbsoluteValue: CGFloat {
        return max(abs(x), abs(y))
    }
}
