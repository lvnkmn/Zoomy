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
        owner?.log(#function, at: Loglevel.verbose)
        guard let owner = owner else { return }
        
        let translation = gestureRecognizer.translation(in: owner.containerView)
        if gestureRecognizer.state == .changed {
            currentTranslation = translation
            currentScale = scale(for: translation)
        } else if gestureRecognizer.state != .began { //.ended, .failed, or .cancelled
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
}
