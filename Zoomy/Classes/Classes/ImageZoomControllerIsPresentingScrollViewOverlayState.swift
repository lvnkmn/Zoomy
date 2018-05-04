import InjectableLoggers

internal class ImageZoomControllerIsPresentingScrollViewOverlayState: NSObject {
    
    // MARK: Private Propeties
    private weak var owner: ImageZoomController?
    private var dominantBouncingDirection: Side?
    private var isZooming = false
    
    /// Makes sure that not every bounce causes can cause this state change
    private let maximumPanTranslationDuringBounceThatTriggersStateChange: CGFloat = 20
    
    // MARK: Initializers
    init(owner: ImageZoomController) {
        self.owner = owner
    }
}

//MARK: ImageZoomControllerState
extension ImageZoomControllerIsPresentingScrollViewOverlayState: ImageZoomControllerState {

    func presentOverlay() {
        owner?.log(#function, at: Loglevel.verbose)
        guard   let owner = owner,
                let containerView = owner.containerView,
                let dominantBouncingSide = dominantBouncingDirection else { return }
        
        containerView.addSubview(owner.overlayImageView)
        
        owner.overlayImageView.frame = neededOverlayImageViewFrame()
        
        owner.state = IsHandlingScrollViewBounceTriggeredDismissalState(owner: owner, translationDirection: dominantBouncingSide)
        
        owner.scrollableImageView.alpha = 0
    }
    
    func dismissOverlay() {
        owner?.log(#function, at: Loglevel.verbose)
        guard   let owner = owner,
                let imageView = owner.imageView else { return }
        
        owner.animator(for: .overlayDismissal).animate({
            owner.scrollView.zoomScale = owner.minimumZoomScale
            owner.scrollView.frame = owner.absoluteFrame(of: imageView)
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
        
        owner.log(#function + " Will bounce. translation: \(translation) ", at: Loglevel.verbose)
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
}

//MARK: CanPerformAction
extension ImageZoomControllerIsPresentingScrollViewOverlayState: CanPerformAction {
    
    func perform(action: ImageZoomControllerAction) {
        owner?.log(#function + " \(action)", at: Loglevel.info)
        guard !(action is NoneAction) else { return }
        if action is DismissOverlayAction {
            presentOverlay() //By presenting the (temporary) imageOverlay we're dismissing the current (scrollView) overlay
        }
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsPresentingScrollViewOverlayState {
    
    func didStartBouncingScroll(in direction: Side) {
        owner?.log(#function, at: Loglevel.verbose)
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
    
    /// [See GitHub Issue](https://github.com/mennolovink/Zoomy/issues/35)
    func neededOverlayImageViewFrame() -> CGRect {
        guard   let owner = owner,
                let image = owner.image else { return CGRect.zero }
        
        return CGRect(origin: owner.absoluteFrame(of: owner.scrollableImageView).origin,
                      size: owner.size(of: image, at: owner.scrollView.zoomScale))
    }
}
