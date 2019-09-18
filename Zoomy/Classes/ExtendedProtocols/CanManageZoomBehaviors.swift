import UIKit

public protocol CanManageZoomBehaviors {
    
    /// Will make the provided imageView zoomable
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed
    ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, below topmostView: UIView?, delegate: Zoomy.Delegate?, settings: Zoomy.Settings)
    
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
    ///   - containerView: The containerView in which the imageView will be zoomed
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView) {
        addZoombehavior(for: imageView, in: containerView, below: nil, delegate: nil, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView zoomable without a delegate
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, in: containerView, below: nil, delegate: nil, settings: settings)
    }
    
    /// Will make the provided imageView zoomable with default settings
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed
    ///   - delegate: The delegate that will be notified on zoom related events
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, delegate: Zoomy.Delegate?) {
        addZoombehavior(for: imageView, in: containerView, below: nil, delegate: delegate, settings: .defaultSettings)
    }
}

//MARK: Where HasImageZoomControllers
public extension CanManageZoomBehaviors where Self: HasImageZoomControllers {
    
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, below topmostView: UIView?, delegate: Zoomy.Delegate?, settings: Zoomy.Settings) {
        if let previousController = imageZoomControllers[imageView] {
            previousController.reset()
        }
        
        imageZoomControllers[imageView] = ImageZoomController(container: containerView, imageView: imageView, topmostView: topmostView, delegate: delegate, settings: settings)
    }
    
    func removeZoomBehavior(for imageView: UIImageView) {
        let imageZoomController = imageZoomControllers[imageView]
        imageZoomController?.reset()
        imageZoomControllers.removeValue(forKey: imageView)
    }
}

//MARK: Where Zoomy.Delegate
public extension CanManageZoomBehaviors where Self: Zoomy.Delegate {
    
    /// Will make the provided imageView zoomable with default settings and where the delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView) {
        addZoombehavior(for: imageView, in: containerView, below: nil, delegate: self, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView where the delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - containerView: The containerView in which the imageView will be zoomed, this should be an ansester of the imageView
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, in containerView: UIView, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, in: containerView, below: nil, delegate: self, settings: settings)
    }
}

//MARK: Where UIViewController
public extension CanManageZoomBehaviors where Self: UIViewController {
    
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView?, delegate: Zoomy.Delegate?, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, in: view, below: topmostView, delegate: delegate, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: All views that show zooming behavior will be placed underneath this view
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView, delegate: Zoomy.Delegate?) {
        addZoombehavior(for: imageView, in: view, below: topmostView, delegate: delegate, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: All views that show zooming behavior will be placed underneath this view
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, below topMostView: UIView, delegate: Zoomy.Delegate?, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, in: view, below: topMostView, delegate: delegate, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - delegate: The delegate that will be notified on zoom related events
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, delegate: Zoomy.Delegate?, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, below: nil, delegate: delegate, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: All views that show zooming behavior will be placed underneath this view
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, below: topmostView, delegate: nil, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    /// - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, delegate: nil, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView, delegate: Zoomy.Delegate?) {
        addZoombehavior(for: imageView, delegate: delegate, settings: .defaultSettings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView) {
        addZoombehavior(for: imageView, below: topmostView, delegate: nil)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    func addZoombehavior(for imageView: UIImageView) {
        addZoombehavior(for: imageView, delegate: nil)
    }
}

//MARK: Where UIViewController, Zoomy.Delegate
public extension CanManageZoomBehaviors where Self: UIViewController, Self: Zoomy.Delegate {
    
    /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView, settings: Zoomy.Settings) {
        addZoombehavior(for: imageView, below: topmostView, delegate: self, settings: settings)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - topMostView: If specified, all views that show zooming behavior will be placed underneath this view
    func addZoombehavior(for imageView: UIImageView, below topmostView: UIView) {
        addZoombehavior(for: imageView, below: topmostView, delegate: self)
    }
    
    /// Will make the provided imageView zoomable inside the viewControllers view and where delegate is self
    ///
    ///   - Parameters:
    ///   - imageView: The imageView that will be zoomable
    ///   - settings: The settings the will be used for the zoomBehavior
    func addZoombehavior(for imageView: UIImageView, settings: Zoomy.Settings) {
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
