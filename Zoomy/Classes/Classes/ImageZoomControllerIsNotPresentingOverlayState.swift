import InjectableLoggers

internal class ImageZoomControllerIsNotPresentingOverlayState {
    
    private weak var owner: ImageZoomController?
    
    init(owner: ImageZoomController) {
        self.owner = owner
    }
}

//MARK: - ImageZoomControllerState
extension ImageZoomControllerIsNotPresentingOverlayState: ImageZoomControllerState {
    
    func presentOverlay() {
        guard   let owner = owner,
                let imageView = owner.imageView,
                let view = owner.containerView else { return }
        logger.log(atLevel: .verbose)
        
        owner.setupImage()

        guard let absoluteFrameOfImageView = owner.initialAbsoluteFrameOfImageView else { return }
        
        imageView.alpha = 0
        
        if owner.settings.shouldDisplayBackground {
            view.addSubview(owner.backgroundView)
            owner.backgroundView.alpha = 0
            owner.backgroundView.autoPinEdgesToSuperviewEdges()
        }
        
        view.addSubview(owner.overlayImageView)
        owner.overlayImageView.image = owner.image
        owner.overlayImageView.frame = absoluteFrameOfImageView
        
        defer {
            owner.delegate?.didBeginPresentingOverlay(for: imageView)
        }
        
        owner.state = IsPresentingImageViewOverlayState(owner: owner)
    }
    
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        logger.logGesture(with: gestureRecognizer, atLevel: .verbose)
        
        presentOverlay()
        guard owner?.state !== self else { return }
        owner?.state.didPinch(with: gestureRecognizer)
    }
}
