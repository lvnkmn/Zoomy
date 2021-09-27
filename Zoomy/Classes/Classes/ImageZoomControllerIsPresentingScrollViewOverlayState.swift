import UIKit

internal class ImageZoomControllerIsPresentingScrollViewOverlayState: NSObject {
    
    // MARK: Private Propeties
    private weak var owner: ImageZoomController?
    private var dominantBouncingDirection: Side?
    private var isZooming = false
    
    /// Makes sure that not every bounce causes can cause this state change
    private let maximumPanTranslationDuringBounceThatTriggersStateChange: CGFloat = 20
    
    private var contentState = ContentState.smallerThanAnsestorView {
        didSet {
            guard   let owner = owner,
                    contentState != oldValue else { return }
            
            logger.log("Changed from \(oldValue) to \(contentState)", atLevel: .info)
            
            owner.animator(for: .backgroundColorChange).animate {
                owner.backgroundView.backgroundColor = self.backgroundColor(for: self.contentState)
                owner.backgroundView.alpha = 1
            }
            
            owner.delegate?.contentStateDidChange(from: oldValue, to: contentState)
        }
    }
    
    // MARK: Initializers
    init(owner: ImageZoomController) {
        self.owner = owner
        super.init()
        defer {
            contentState = neededContentState()
        }
    }
}

//MARK: ImageZoomControllerState
extension ImageZoomControllerIsPresentingScrollViewOverlayState: ImageZoomControllerState {

    func presentOverlay() {
        logger.log(atLevel: Loglevel.verbose)
        guard   let owner = owner,
                let containerView = owner.containerView,
                let dominantBouncingSide = dominantBouncingDirection else { return }
        
        if let topmostView = owner.topmostView {
            containerView.insertSubview(owner.overlayImageView, belowSubview: topmostView)
        } else {
            containerView.addSubview(owner.overlayImageView)
        }
        
        owner.overlayImageView.frame = neededOverlayImageViewFrame()
        
        owner.state = IsHandlingScrollViewBounceTriggeredDismissalState(owner: owner, translationDirection: dominantBouncingSide)
        
        owner.scrollableImageView.alpha = 0
    }
    
    func dismissOverlay() {
        logger.log(atLevel: Loglevel.verbose)
        guard   let owner = owner,
                let imageView = owner.imageView,
                let absoluteFrameOfImageView = owner.initialAbsoluteFrameOfImageView else { return }
        
        owner.delegate?.willDismissOverlay()
        
        owner.animator(for: .overlayDismissal).animate({
            owner.scrollView.zoomScale = owner.minimumZoomScale
            owner.scrollView.frame = absoluteFrameOfImageView
        }) {
            owner.reset()
            owner.configureImageView()
            owner.delegate?.didEndPresentingOverlay(for: imageView)
        }
        
        if owner.settings.shouldDisplayBackground {
            owner.animator(for: .backgroundColorChange).animate {
                owner.backgroundView.alpha = 0
            }
        }
    }
    
    func zoomIn(with gestureRecognizer: UIGestureRecognizer?) {
        guard   let scrollView = owner?.scrollView,
                scrollView.zoomScale != scrollView.maximumZoomScale else { return }
        
        if let location = gestureRecognizer?.location(in: gestureRecognizer?.view) {
            logger.log("location: \(location)", atLevel: .verbose)
            scrollView.zoom(to: CGRect(x: location.x, y: location.y, width: 0, height: 0), animated: true)
        } else {
            logger.log("zoomScale: \(scrollView.maximumZoomScale)", atLevel: .verbose)
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
    
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: owner?.containerView)
        guard   isZooming == false,
                let owner = owner,
                let currentBounceOffsets = owner.currentBounceOffsets,
                let dominantBouncingDirection = currentBounceOffsets.bouncingSides().first,
                translation.dominantDirection == dominantBouncingDirection,
                translation.value(in: dominantBouncingDirection) < maximumPanTranslationDuringBounceThatTriggersStateChange else { return }

        self.dominantBouncingDirection = dominantBouncingDirection
        gestureRecognizer.setTranslation(CGPoint.zero, in: owner.containerView)
        
        logger.log(" Will bounce. translation: \(translation) ", atLevel: .verbose)
        didStartBouncingScroll(in: dominantBouncingDirection)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        isZooming = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        isZooming = false

        guard let owner = owner else { return }
        
        if  scrollView.zoomScale <= owner.minimumZoomScale ||
            scrollView.zoomScale <= owner.zoomScale(from: owner.settings.zoomCancelingThreshold) {
            dismissOverlay()
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        contentState = neededContentState()
    }
}

//MARK: CanPerformAction
extension ImageZoomControllerIsPresentingScrollViewOverlayState: CanPerformAction {
    
    func perform(action: ImageZoomControllerAction, triggeredBy gestureRecognizer: UIGestureRecognizer? = nil) {
        logger.log(action, atLevel: .info)
        guard !(action is Action.None) else { return }
        if action is Action.DismissOverlay {
            presentOverlay() //By presenting the (temporary) imageOverlay we're dismissing the current (scrollView) overlay
        }
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsPresentingScrollViewOverlayState {
    
    func didStartBouncingScroll(in direction: Side) {
        logger.log(atLevel: .verbose)
        perform(action: action(for: direction))
    }
    
    func action(for side: Side) -> Action {
        guard let settings = owner?.settings else { return .none }
        switch side {
        case .top:
            return settings.actionOnScrollBounceTop
        case .left:
            return settings.actionOnScrollBounceLeft
        case .right:
            return settings.actionOnScrollBounceRight
        case .bottom:
            return settings.actionOnScrollBounceBottom
        }
    }
    
    /// [See GitHub Issue](https://github.com/lvnkmn/Zoomy/issues/35)
    func neededOverlayImageViewFrame() -> CGRect {
        guard   let owner = owner,
                let image = owner.image else { return CGRect.zero }
        
        return CGRect(origin: owner.absoluteFrame(of: owner.scrollableImageView).origin,
                      size: owner.size(of: image, at: owner.scrollView.zoomScale))
    }
    
    func backgroundColor(for state: ImageZoomControllerContentState) -> UIColor {
        guard let owner = owner else { return UIColor() }
        switch state {
        case .smallerThanAnsestorView:
            return owner.settings.primaryBackgroundColor
        case .fillsAnsestorView:
            return owner.settings.secondaryBackgroundColor
        }
    }
    
    func neededContentState() -> ImageZoomControllerContentState {
        guard   let containerView = owner?.containerView,
                let scrollView = owner?.scrollView else { return .smallerThanAnsestorView }
        
        return  scrollView.contentSize.width >= containerView.frame.size.width ||
                scrollView.contentSize.height >= containerView.frame.size.height ?      .fillsAnsestorView :
                                                                                        .smallerThanAnsestorView
    }
}
