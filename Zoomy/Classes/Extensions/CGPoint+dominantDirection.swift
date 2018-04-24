internal extension CGPoint {
    var dominantDirection: Side {
        let top = value(in: .top)
        let left = value(in: .left)
        let right = value(in: .right)
        let bottom = value(in: .bottom)

        if  top > left, top > right, top > bottom {
            return .top
        } else if left > top, left > right, left > bottom {
            return .left
        } else if right > top, right > left, right > bottom {
            return .right
        } else {
            return .bottom
        }
    }
}
