import InjectableLoggers

internal class ImageZoomControllerIsHandlingScrollViewBounceTriggeredDismissalState: ImageZoomControllerIsPresentingImageViewOverlayState {
    
    // MARK: Private Properties
    private let translationDirection: Side
    private let initialZoomScale: ImageScale
    
    // MARK: Initializers
    init(owner: ImageZoomController, translationDirection: Side) {
        self.translationDirection = translationDirection
        self.initialZoomScale = owner.scrollView.zoomScale
        super.init(owner: owner)
    }
    
    // MARK: ImageZoomControllerIsPresentingImageViewOverlayState
    override func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        guard let owner = owner else { return }
        
        let translation = gestureRecognizer.translation(in: owner.containerView)
        if gestureRecognizer.state == .changed {
            currentTranslation = translation
            currentScale = scale(for: translation)
            owner.backgroundView.alpha = backgroundAlpha(for: translation.value(in: translation.dominantDirection))
        } else if gestureRecognizer.state != .began { //.ended, .failed, or .cancelled
            guard !isDismissingOverlay else { return }
            
            if translation.value(in: translationDirection) >= owner.settings.neededTranslationToDismissOverlayOnScrollBounce {
                owner.resetScrollView()
                dismissOverlay()
            } else {
                owner.resetScrollView()
                presentOverlay()
            }
        }
    }
    
    override func neededScrolllViewZoomScale() -> ImageScale {
        return initialZoomScale
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsHandlingScrollViewBounceTriggeredDismissalState {
    
    func scale(for translation: CGPoint) -> ImageViewScale {
        let translationForMinimumZoom: CGFloat = 500
        let minimumScale: CGFloat = 0.5
        let delta = 1 - minimumScale
        
        return 1 - (min(translation.value(in: translationDirection), translationForMinimumZoom) / translationForMinimumZoom) * delta
    }
    
    func backgroundAlpha(for translation: CGFloat) -> CGFloat {
        guard let owner = owner else { return 0 }
        let progress = (translation / owner.settings.backgroundAlphaDismissalTranslationThreshold)
        return max(min(1 - progress, 1), 0)
    }
}
