internal class ImageZoomControllerIsPresentingScrollViewOverlayState: NSObject {
    
    // MARK: Private Propeties
    private weak var owner: ImageZoomController?
    private var dominantBouncingDirection: Side?
    
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
        guard   let owner = owner,
                let containerView = owner.containerView,
                let dominantBouncingSide = dominantBouncingDirection else { return }
        
        containerView.addSubview(owner.overlayImageView)
        
        owner.overlayImageView.frame = owner.absoluteFrame(of: owner.scrollableImageView)
        owner.state = IsHandlingScrollViewBounceTriggeredDismissalState(owner: owner, translationDirection: dominantBouncingSide)
        
        owner.scrollableImageView.alpha = 0
    }
    
    func dismissOverlay() {
        guard   let owner = owner,
                let imageView = owner.imageView else { return }
        
        animateSpring(withAnimations: {
            owner.scrollView.zoomScale = owner.minimumZoomScale
            owner.scrollView.frame = owner.absoluteFrame(of: imageView)
        }) { _ in
            owner.reset()
            owner.configureImageView()
            owner.delegate?.didEndPresentingOverlay(for: imageView)
        }
        
        if owner.settings.shouldDisplayBackground {
            animate {
                owner.backgroundView.alpha = 0
            }
        }
    }
    
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: owner?.containerView)
        guard   let owner = owner,
                let currentBounceOffsets = owner.currentBounceOffsets,
                let dominantBouncingDirection = currentBounceOffsets.bouncingSides().first,
                translation.dominantDirection == dominantBouncingDirection,
                translation.value(in: dominantBouncingDirection) < maximumPanTranslationDuringBounceThatTriggersStateChange else { return }

        self.dominantBouncingDirection = dominantBouncingDirection
        gestureRecognizer.setTranslation(CGPoint.zero, in: owner.containerView)
        
        didStartBouncingScroll(in: dominantBouncingDirection)
    }
}

//MARK: CanPerformAction
extension ImageZoomControllerIsPresentingScrollViewOverlayState: CanPerformAction {
    
    func perform(action: ImageZoomControllerAction) {
        guard !(action is NoneAction) else { return }
        
        if action is DismissOverlayAction {
            presentOverlay() //By presenting the (temporary) imageOverlay we're dismissing the current (scrollView) overlay
        }
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsPresentingScrollViewOverlayState {
    
    func didStartBouncingScroll(in direction: Side) {
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
}
