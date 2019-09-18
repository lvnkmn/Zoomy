import UIKit

internal extension CGRect {
    func difference(with rect: CGRect) -> CGRect {
        return CGRect(x: origin.x - rect.origin.x,
                      y: origin.y - rect.origin.y,
                      width: size.width - rect.size.width,
                      height: size.height - rect.size.height)
    }
}
