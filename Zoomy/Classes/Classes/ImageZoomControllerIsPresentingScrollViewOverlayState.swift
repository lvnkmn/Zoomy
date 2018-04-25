internal class ImageZoomControllerIsPresentingScrollViewOverlayState {
    
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
                translation.value(in: dominantBouncingDirection) < maximumPanTranslationDuringBounceThatTriggersStateChange,
                dominantBouncingDirection == .bottom else { return }

        self.dominantBouncingDirection = dominantBouncingDirection
        
        gestureRecognizer.setTranslation(CGPoint.zero, in: owner.containerView)
        presentOverlay()
    }
}

