import Foundation
import InjectableLoggers

public class ImageZoomController: NSObject {
    // MARK: Public Properties
    
    /// Gets callbacks on important events in the ImageZoomController's lifeCycle
    public weak var delegate: Zoomy.Delegate?
    
    public var settings: Settings
    
    /// View in which zoom will take place
    weak public private(set) var containerView: UIView?
    
    /// View which will always be in front of the presented zoom content
    weak public private(set) var topmostView: UIView?
    
    /// The imageView that is to be the source of the zoom interactions
    weak public private(set) var imageView: UIImageView?
    
    /// When zoom gesture ends while currentZoomScale is below minimumZoomScale, the overlay will be dismissed
    public private(set) lazy var minimumZoomScale = zoomScale(from: imageView)
    
    // MARK: Internal Properties
    internal private(set) var image: UIImage? {
        didSet {
            guard let image = image else { return }
            logger.log("Changed to \(image)", atLevel: Loglevel.info)
            minimumZoomScale = zoomScale(from: imageView)
            initialAbsoluteFrameOfImageView = absoluteFrame(of: imageView)
        }
    }
    
    internal var state: State! {
        didSet {
            guard let state = state else { return }
            logger.log("Changed to \(state)", atLevel: .info)
        }
    }
    
    internal var shouldAdjustScrollViewFrameAfterZooming = true
    
    internal var currentBounceOffsets: BounceOffsets?
    
    /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
    internal var minimumPinchScale: ImageViewScale {
        return pinchScale(from: minimumZoomScale)
    }

    /// [See GitHub Issue](https://github.com/lvnkmn/Zoomy/issues/40)
    internal var initialAbsoluteFrameOfImageView: CGRect? {
        didSet {
            guard let initialAbsoluteFrameOfImageView = initialAbsoluteFrameOfImageView else { return }
            logger.log("changed to \(initialAbsoluteFrameOfImageView)", atLevel: .verbose)
        }
    }
    
    internal private (set) lazy var scrollableImageView = factory.makeScrollableImageView(for: self)
    internal private (set) lazy var overlayImageView = factory.makeOverlayImageView(for: self)
    internal private (set) lazy var scrollView = factory.makeScrollView(for: self)
    internal private (set) lazy var backgroundView = factory.makeBackgroundView(for: self)
    
    internal private (set) lazy var imageViewPinchGestureRecognizer = factory.makePinchGestureRecognizer(for: self)
    internal private (set) lazy var imageViewPanGestureRecognizer = factory.makePanGestureRecognizer(for: self)
    internal private (set) lazy var imageViewTapGestureRecognizer = factory.makeTapGestureRecognizer(for: self)
    internal private (set) lazy var imageViewDoubleTapGestureRecognizer = factory.makeDoubleTapGestureRecognizer(for: self)

    internal private (set) lazy var backgroundViewTapGestureRecognizer = factory.makeTapGestureRecognizer(for: self)
    internal private (set) lazy var backgroundViewDoubleTapGestureRecognizer = factory.makeDoubleTapGestureRecognizer(for: self)
    
    internal private (set) lazy var scrollableImageViewTapGestureRecognizer = factory.makeTapGestureRecognizer(for: self)
    internal private (set) lazy var scrollableImageViewDoubleTapGestureRecognizer = factory.makeDoubleTapGestureRecognizer(for: self)
    internal private (set) lazy var scrollableImageViewPanGestureRecognizer = factory.makePanGestureRecognizer(for: self)
    
    // MARK: Private Properties
    private let factory: Factory
    
    /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
    private var maximumPinchScale: ImageViewScale {
        return pinchScale(from: settings.maximumZoomScale)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - delegate: delegate
    ///   - settings: mutable settings that will be applied on this ImageZoomController
    public convenience init(container containerView: UIView,
                            imageView: UIImageView,
                            delegate: Zoomy.Delegate?,
                            settings: Settings) {
        self.init(container: containerView, imageView: imageView, topmostView: nil, delegate: delegate, settings: settings)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    public convenience init(container containerView: UIView, imageView: UIImageView) {
        self.init(container: containerView, imageView: imageView, delegate: nil, settings: .defaultSettings)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - delegate: delegate
    public convenience init(container containerView: UIView, imageView: UIImageView, delegate: ImageZoomControllerDelegate) {
        self.init(container: containerView, imageView: imageView, delegate: delegate, settings: .defaultSettings)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - settings: mutable settings that will be applied on this ImageZoomController
    public convenience init(container containerView: UIView, imageView: UIImageView, settings: ImageZoomControllerSettings) {
        self.init(container: containerView, imageView: imageView, delegate: nil, settings: settings)
    }
    
    internal init(container containerView: UIView,
                           imageView: UIImageView,
                           topmostView: UIView?,
                           delegate: Zoomy.Delegate?,
                           settings: Settings,
                           factory: Factory = Factory()) {
        logger.log(atLevel: .info)
        self.containerView = containerView
        self.topmostView = topmostView
        self.imageView = imageView
        self.delegate = delegate
        self.settings = settings
        self.factory = factory
        
        super.init()
        
        state = IsNotPresentingOverlayState(owner: self)
        configureImageView()
        logger.log("done\n", atLevel: .verbose)
    }
    
    // MARK: Deinitalizer
    deinit {
        logger.log(atLevel: .info)
        imageView?.removeGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewPanGestureRecognizer)
    }
}

//MARK: Public methods
public extension ImageZoomController {
    
    /// Dismiss all currently presented overlays
    func dismissOverlay() {
        state.dismissOverlay()
    }
    
    /// Reset imageView and viewHierarchy to the state prior to initializing the zoomControlelr
    func reset() {
        imageView?.removeGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewPanGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewTapGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewDoubleTapGestureRecognizer)
        imageView?.alpha = 1
        
        resetOverlayImageView()
        resetScrollView()
        
        if settings.shouldDisplayBackground {
            backgroundView.removeFromSuperview()
        }
        
        state = IsNotPresentingOverlayState(owner: self)
        logger.log("Did reset\n\n\n\n\n\n\n\n", atLevel: .verbose)
    }
}

//MARK: Events
extension ImageZoomController {
    
    @objc func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
        logger.logGesture(with: gestureRecognizer, atLevel: .verbose)
        guard settings.isEnabled else { return }
        
        state.didPinch(with: gestureRecognizer)
    }
    
    @objc func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        logger.logGesture(with: gestureRecognizer, atLevel: .verbose)
        guard settings.isEnabled else { return }
        
        state.didPan(with: gestureRecognizer)
    }
    
    @objc func didTap(with gestureRecognizer: UITapGestureRecognizer) {
        logger.log(atLevel: .verbose)
        guard   settings.isEnabled,
                let action = gestureRecognizerActions[gestureRecognizer] else { return }
        
        perform(action: action, triggeredBy: gestureRecognizer)
    }
}

//MARK: CanPerformAction
extension ImageZoomController: CanPerformAction {
    
    func perform(action: ImageZoomControllerAction, triggeredBy gestureRecognizer: UIGestureRecognizer? = nil) {
        logger.log(action, atLevel: .info)
        guard !(action is Action.None) else { return }
        
        if action is Action.DismissOverlay {
            state.dismissOverlay()
        } else if action is Action.ZoomToFit {
            state.zoomToFit()
        } else if action is Action.ZoomIn {
            state.zoomIn(with: gestureRecognizer)
        }
    }
}

//MARK: Setup
extension ImageZoomController {

    internal func configureImageView() {
        logger.log(atLevel: .verbose)
        imageView?.addGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.addGestureRecognizer(imageViewPanGestureRecognizer)
        imageView?.addGestureRecognizer(imageViewTapGestureRecognizer)
        imageView?.addGestureRecognizer(imageViewDoubleTapGestureRecognizer)
        imageView?.isUserInteractionEnabled = true
    }
    
    func setupImage() {
        validateImageView()
        self.image = imageView?.image
    }
    
    private func validateImageView() {
        guard let imageView = imageView else { return }
        
        if  imageView.image == nil,
            settings.shouldLogWarningsAndErrors {
            logger.log("Provided imageView did not have an image at this time, this is likely to have effect on the zoom behavior.", atLevel: .warning)
        }
    }
}

//MARK: Calculations
internal extension ImageZoomController {
    
    func adjustedScrollViewFrame() -> CGRect {
        guard   let containerView = containerView,
                let initialAbsoluteFrameOfImageView = initialAbsoluteFrameOfImageView else { return CGRect.zero }
        
        let initialHorizontalLeadingSpaceToContainer = initialAbsoluteFrameOfImageView.origin.x
        let initialHorizontalSpaceToContainer = containerView.frame.size.width - initialAbsoluteFrameOfImageView.width
        let leadingHorizontalSpaceRatio = initialHorizontalSpaceToContainer != 0 ? initialHorizontalLeadingSpaceToContainer / initialHorizontalSpaceToContainer : 0

        let widthGrowth = (scrollView.contentSize.width - initialAbsoluteFrameOfImageView.width)
        
        let originX = max(initialAbsoluteFrameOfImageView.origin.x - widthGrowth * leadingHorizontalSpaceRatio, 0)
        let originY = max(initialAbsoluteFrameOfImageView.origin.y - (scrollView.contentSize.height - initialAbsoluteFrameOfImageView.height) / 2, 0)
        let width = min(scrollView.contentSize.width, containerView.frame.width)
        let height = min(scrollView.contentSize.height, containerView.frame.height)

        return CGRect(x: originX,
                      y: originY,
                      width: width,
                      height: height)
    }
    
    /// Shows how much the provided content offset will be corrected if applied to the scrollView
    ///
    /// - Parameter contentOffset: the contentOffset
    /// - Returns: the correction
    func contentOffsetCorrection(on contentOffset: CGPoint) -> CGPoint {
        let x: CGFloat
        if contentOffset.x < 0 {
            x = contentOffset.x
        } else if contentOffset.x - (scrollView.contentSize.width - scrollView.frame.size.width) > 0 {
            x = contentOffset.x - (scrollView.contentSize.width - scrollView.frame.size.width)
        } else {
            x = 0
        }
        
        let y: CGFloat
        if contentOffset.y + adjustedContentInset(from: scrollView).top < 0 {
            y = contentOffset.y + adjustedContentInset(from: scrollView).top
        } else if contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height + adjustedContentInset(from: scrollView).bottom) > 0 {
            y = contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height + adjustedContentInset(from: scrollView).bottom)
        } else {
            y = 0
        }
        
        return CGPoint(x: x, y: y)
    }
    
    /// Returns what the provided contentOffset will turn into when applied on the scrollView
    ///
    /// - Parameter contentOffset: contentOffset
    /// - Returns: corrected contentOffset
    func corrected(contentOffset: CGPoint) -> CGPoint {
        let correction = contentOffsetCorrection(on: contentOffset)
        return CGPoint(x: contentOffset.x - correction.x,
                       y: contentOffset.y - correction.y)
    }

    func zoomScale(from imageView: UIImageView?) -> ImageScale {
        guard   let imageView = imageView,
                let image = image else { return 1 }
        return imageView.frame.size.width / image.size.width
    }
    
    func zoomScale(from pinchScale: ImageViewScale) -> ImageScale {
        return pinchScale * minimumZoomScale
    }
    
    func pinchScale(from zoomScale: ImageScale) -> ImageViewScale {
        return zoomScale / minimumZoomScale
    }
    
    /// Adds the bounce like behavior to the provided pinchScale
    ///
    /// - Parameter pinchScale: pinchScale
    /// - Returns: pinchScale
    func adjust(pinchScale: ImageViewScale) -> ImageViewScale {
        guard   pinchScale < minimumPinchScale ||
                pinchScale > maximumPinchScale else { return pinchScale }
 
        let bounceScale = sqrt(3)
        let x: ImageViewScale
        let k: ImageViewScale
        if pinchScale < minimumPinchScale {
            x = pinchScale / minimumPinchScale
            k = ImageViewScale(1/bounceScale)
            return minimumPinchScale * ((2 * k - 1) * pow(x, 3) + (2 - 3 * k) * pow(x, 2) + k)
        } else { // pinchScale > maximumPinchScale
            x = pinchScale / maximumPinchScale
            k = ImageViewScale(bounceScale)
            return maximumPinchScale * ((2 * k - 2) / (1 + exp(4 / k * (1 - x))) - k + 2)
        }
    }
    
    func absoluteFrame(of subjectView: UIView?) -> CGRect {
        guard   let subjectView = subjectView,
                let view = containerView else { return CGRect.zero }
        
        return view.convert(subjectView.frame, from: subjectView.superview)
    }
    
    func maximumImageSize() -> CGSize {
        guard let imageView = imageView else { return CGSize.zero }
        let view = UIView()
        view.frame = imageView.frame
        view.transform = view.transform.scaledBy(x: maximumPinchScale, y: maximumPinchScale)
        return view.frame.size
    }
    
    func adjustedContentInset(from scrollView: UIScrollView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return scrollView.adjustedContentInset
        } else {
            return scrollView.contentInset
        }
    }
    
    func bounceOffsets(from scrollView: UIScrollView) -> BounceOffsets {
        return BounceOffsets(top: max(scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height) - adjustedContentInset(from: scrollView).bottom, 0),
                             left: max(scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.frame.size.width) - adjustedContentInset(from: scrollView).left, 0),
                             bottom: abs(min(scrollView.contentOffset.y + adjustedContentInset(from: scrollView).top, 0)),
                             right: abs(min(scrollView.contentOffset.x + adjustedContentInset(from: scrollView).right, 0)))
    }
    
    func imageDoesntFitScreen() -> Bool {
        guard let view = containerView else { return false }
        return scrollView.contentSize.width > view.frame.size.width
    }
    
    func size(of image: UIImage, at zoomScale: ImageScale) -> CGSize {
        return CGSize(width: image.size.width * zoomScale,
                      height: image.size.height * zoomScale)
    }
}

//MARK: Other
internal extension ImageZoomController {
    
    private var gestureRecognizerActions: [UIGestureRecognizer: Action] {
        return [imageViewTapGestureRecognizer: settings.actionOnTapImageView,
                imageViewDoubleTapGestureRecognizer: settings.actionOnDoubleTapImageView,
                backgroundViewTapGestureRecognizer: settings.actionOnTapBackgroundView,
                backgroundViewDoubleTapGestureRecognizer: settings.actionOnDoubleTapBackgroundView,
                scrollableImageViewTapGestureRecognizer: settings.actionOnTapOverlay,
                scrollableImageViewDoubleTapGestureRecognizer: settings.actionOnDoubleTapOverlay]
    }
    
    private func adjustFrame(of scrollView: UIScrollView) {
        let oldScrollViewFrame = scrollView.frame
        scrollView.frame = adjustedScrollViewFrame()
        let frameDifference = scrollView.frame.difference(with: oldScrollViewFrame)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + frameDifference.origin.x,
                                           y: scrollView.contentOffset.y + frameDifference.origin.y)
    }
    
    func resetScrollView() {
        scrollableImageView.removeFromSuperview()
        scrollableImageView = factory.makeScrollableImageView(for: self)
        scrollView.removeFromSuperview()
        scrollView = factory.makeScrollView(for: self)
        currentBounceOffsets = nil
    }
    
    func resetOverlayImageView() {
        overlayImageView.removeFromSuperview()
        overlayImageView = factory.makeOverlayImageView(for: self)
    }
}

//MARK: CanProvideAnimatorForEvent
extension ImageZoomController: CanProvideAnimatorForEvent {
    
    public func animator(for event: AnimationEvent) -> CanAnimate {
        return delegate?.animator(for: event) ?? settings.defaultAnimators.animator(for: event)
    }
}

// MARK: UIScrollViewDelegate
extension ImageZoomController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollableImageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if shouldAdjustScrollViewFrameAfterZooming {
            adjustFrame(of: scrollView)
        }
        
        state.scrollViewDidZoom(scrollView)
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        logger.log(atLevel: .verbose)
        state.scrollViewWillBeginZooming(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        logger.log(atLevel: .verbose)
        state.scrollViewDidEndZooming(scrollView, with: view, atScale: scale)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        state.scrollViewWillBeginDragging(scrollView)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentBounceOffsets = bounceOffsets(from: scrollView)
    }
}

//MARK: UIGestureRecognizerDelegate
extension ImageZoomController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let action = gestureRecognizerActions[gestureRecognizer] else { return true }
        
        return !(action is Action.None)
    }
}
