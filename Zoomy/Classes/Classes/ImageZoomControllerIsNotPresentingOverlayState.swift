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
        
        imageView.alpha = 0
        
        if owner.settings.shouldDisplayBackground {
            view.addSubview(owner.backgroundView)
            owner.backgroundView.alpha = 0
            owner.backgroundView.autoPinEdgesToSuperviewEdges()
        }
        
        view.addSubview(owner.overlayImageView)
        owner.overlayImageView.image = owner.imageView?.image
        owner.overlayImageView.frame = owner.absoluteFrame(of: imageView)
        
        defer {
            owner.delegate?.didBeginPresentingOverlay(for: imageView)
        }
        
        owner.state = IsPresentingImageViewOverlayState(owner: owner)
    }
    
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        
        presentOverlay()
        owner?.state.didPinch(with: gestureRecognizer)
    }
}
