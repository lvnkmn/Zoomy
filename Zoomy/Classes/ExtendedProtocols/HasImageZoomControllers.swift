import UIKit

public protocol HasImageZoomControllers: class {
    
    var imageZoomControllers: [UIImageView: ImageZoomController] { get set }
}

public extension HasImageZoomControllers where Self: NSObject {
    
    var imageZoomControllers: [UIImageView: ImageZoomController] {
        get {
            if let existingZoomControllers = objc_getAssociatedObject(self, &type(of: self).AsociatedKeys.imageZoomControllers) as? [UIImageView: ImageZoomController] {
                return existingZoomControllers
            } else {
                let newZoomControllers = [UIImageView: ImageZoomController]()
                objc_setAssociatedObject(self, &type(of: self).AsociatedKeys.imageZoomControllers, newZoomControllers, .OBJC_ASSOCIATION_RETAIN)
                return newZoomControllers
            }
        }
        set {
            objc_setAssociatedObject(self, &type(of: self).AsociatedKeys.imageZoomControllers, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}
