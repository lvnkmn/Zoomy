import UIKit

//The amounts of translation that is being bounced in a UIScrollView
internal struct BounceOffsets {
    
    public var top: CGFloat {
        get {
            return offsets[.top] ?? 0
        }
        set {
            offsets[.top] = newValue
        }
    }
    
    public var left: CGFloat {
        get {
            return offsets[.left] ?? 0
        }
        set {
            offsets[.left] = newValue
        }
    }
    
    public var bottom: CGFloat {
        get {
            return offsets[.bottom] ?? 0
        }
        set {
            offsets[.bottom] = newValue
        }
    }
    
    public var right: CGFloat {
        get {
            return offsets[.right] ?? 0
        }
        set {
            offsets[.right] = newValue
        }
    }
    
    private var offsets: [Side: CGFloat]
    
    public init(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        var offsets = [Side: CGFloat]()
        offsets[.top] = top
        offsets[.left] = left
        offsets[.right] = right
        offsets[.bottom] = bottom
        
        self.offsets = offsets
    }
}

extension BounceOffsets {
    var isBouncing: Bool {
        return  top > 0 ||
                right > 0 ||
                left > 0 ||
                bottom > 0
    }
    
    
    /// The sides that are currently bouncing in order of dominance (bouncing more -> earlier in the array)
    func bouncingSides() -> [Side] {
        return offsets.filter{ $0.value > 0 }.sorted(by: { $0.value > $1.value }).map{ $0.key }
    }
    
    func isBouncing(side: Side) -> Bool {
        return offset(for: side) > 0
    }
    
    func offset(for side: Side) -> CGFloat {
        return offsets[side] ?? 0
    }
}
