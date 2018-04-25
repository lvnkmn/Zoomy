import Foundation

public protocol CanManageZoomBehaviors {
    
    /// Will make the provided imageView zoomable
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, delegate: ZoomDelegate?, settings: ZoomSettings)
    
    
    /// Will make the provided imageView no longer zoomable, it's state will be restored the the state prior to adding a zoomBehehavior for it
    ///
    /// - Parameter imageView: The imageView that should no longer be zoomable
    func removeZoomBehavior(for imageView: UIImageView)
}

public extension CanManageZoomBehaviors {
    
    /// Will make the provided imageView zoomable with default settings and without a delegate
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView) {
        addZoombehavior(for: imageView, in: containerView, delegate: nil, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView zoomable without a delegate
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, settings: ZoomSettings) {
        addZoombehavior(for: imageView, in: containerView, delegate: nil, settings: settings)
    }
    
    /// Will make the provided imageView zoomable with default settings
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - delegate: The delegate that will be notified on zoom related events
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, delegate: ZoomDelegate?) {
        addZoombehavior(for: imageView, in: containerView, delegate: delegate, settings: .defaultSettings)
    }
}

public extension CanManageZoomBehaviors where Self: HasImageZoomControllers {
    
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, delegate: ZoomDelegate?, settings: ZoomSettings) {
        if let previousController = imageZoomControllers[imageView] {
            previousController.reset()
        }
        
        imageZoomControllers[imageView] = ImageZoomController(container: containerView, imageView: imageView, delegate: delegate, settings: settings)
    }
    
    func removeZoomBehavior(for imageView: UIImageView) {
        let imageZoomController = imageZoomControllers[imageView]
        imageZoomController?.reset()
        imageZoomControllers.removeValue(forKey: imageView)
    }
}

public extension CanManageZoomBehaviors where Self: ZoomDelegate {
    
    /// Will make the provided imageView zoomable with default settings and where the delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView) {
        addZoombehavior(for: imageView, in: containerView, delegate: self, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView where the delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, settings: ZoomSettings) {
        addZoombehavior(for: imageView, in: containerView, delegate: self, settings: settings)
    }
}

public extension CanManageZoomBehaviors where Self: UIViewController {
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, delegate: ZoomDelegate?, settings: ZoomSettings) {
        addZoombehavior(for: imageView, in: view, delegate: delegate, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view without a delegate
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, settings: ZoomSettings) {
        addZoombehavior(for: imageView, delegate: nil, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view with default settings
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView, delegate: ZoomDelegate?) {
        addZoombehavior(for: imageView, delegate: delegate, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view with default settings and without a delegate
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView) {
        addZoombehavior(for: imageView, delegate: nil)
    }
}

public extension CanManageZoomBehaviors where Self: UIViewController, Self: ZoomDelegate {
    
    /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, settings: ZoomSettings) {
        addZoombehavior(for: imageView, delegate: self, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view with default settings and where delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView) {
        addZoombehavior(for: imageView, delegate: self)
    }
}
