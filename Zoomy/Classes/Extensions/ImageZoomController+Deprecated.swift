import UIKit

public extension ImageZoomController {
    
    @available(*, deprecated, message: "Use init(container containerView: UIView, imageView: UIImageView, delegate: ImageZoomControllerDelegate?, settings: ImageZoomControllerSettings) instead")
    convenience init(view: UIView,
                            imageView:UIImageView,
                            delegate: ImageZoomControllerDelegate?,
                            settings: ImageZoomControllerSettings) {
        self.init(container: view, imageView: imageView, delegate: delegate, settings: settings)
    }
    
    @available(*, deprecated, message: "Use init(container containerView: UIView, imageView: UIImageView) instead")
    convenience init(view: UIView, imageView: UIImageView) {
        self.init(container: view, imageView: imageView, delegate: nil, settings: .defaultSettings)
    }
    
    @available(*, deprecated, message: "Use init(container containerView: UIView, imageView: UIImageView, delegate: ImageZoomControllerDelegate) instead")
    convenience init(view: UIView, imageView: UIImageView, delegate: ImageZoomControllerDelegate) {
        self.init(container: view, imageView: imageView, delegate: delegate, settings: .defaultSettings)
    }
    
    @available(*, deprecated, message: "Use init(container containerView: UIView, imageView: UIImageView, settings: ImageZoomControllerSettings) instead")
    convenience init(view: UIView, imageView: UIImageView, settings: ImageZoomControllerSettings) {
        self.init(container: view, imageView: imageView, delegate: nil, settings: settings)
    }
}
