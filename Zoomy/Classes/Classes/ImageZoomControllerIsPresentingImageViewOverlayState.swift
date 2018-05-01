import InjectableLoggers

internal class ImageZoomControllerIsPresentingImageViewOverlayState {
    
    // MARK: Internal Properties
    internal weak var owner: ImageZoomController?
    
    internal var currentTranslation = CGPoint.zero {
        didSet {
            updateOverlayImageViewTransform()
        }
    }
    
    internal var currentScale: ImageViewScale = 1 {
        didSet {
            updateOverlayImageViewTransform()
        }
    }
    
    // MARK: Private properties
    private var isDismissingOverlay = false {
        didSet {
            owner?.log("\(#function) \(isDismissingOverlay)", at: Loglevel.verbose)
            let generateWarning = true //Revert when done testing:
            if isDismissingOverlay == false {
                print()
            }
        }
    }
    private var neededContentOffSet: CGPoint?
    private var contentOffsetCorrectionDueToZoomDifference: CGPoint?
    private var expectedFrameOfScrollableImageView: CGRect?
    
    private var isBypasssingAnimateToExpectedFrameOfScrollableImageView = false {
        didSet {
            owner?.log("\(#function) \(isBypasssingAnimateToExpectedFrameOfScrollableImageView)", at: Loglevel.verbose)
        }
    }
    
    private var pinchCenter: CGPoint?
    
    // MARK: Initializers
    init(owner: ImageZoomController) {
        self.owner = owner
    }
}

//MARK: ImageZoomControllerState
extension ImageZoomControllerIsPresentingImageViewOverlayState: ImageZoomControllerState {
    
    @objc func presentOverlay() {
        owner?.log(#function, at: Loglevel.verbose)
        guard let owner = owner else { return }
        
        configureScrollView()
        
        if owner.overlayImageView.frame == calculateExpectedFrameOfScrollableImageView() {
            finishPresentingOverlayImageView()
        } else {
            animateToExpectedFrameOfScrollableImageView(onComplete: finishPresentingOverlayImageView)
        }
    }
    
    func dismissOverlay() {
        owner?.log(#function, at: Loglevel.verbose)
        guard   let owner = owner,
                let imageView = owner.imageView else { return }
        
        isDismissingOverlay = true
        owner.scrollView.removeFromSuperview()
        
        owner.animator(for: .overlayDismissal).animate({
            owner.overlayImageView.frame = owner.absoluteFrame(of: imageView)
        }) {
            owner.reset()
            owner.configureImageView()
            self.isDismissingOverlay = false
            owner.delegate?.didEndPresentingOverlay(for: imageView)
        }
        
        if owner.settings.shouldDisplayBackground {
            owner.animator(for: .backgroundColorChange).animate {
                owner.backgroundView.alpha = 0
            }
        }
    }
    
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
        guard   let owner = owner,
                let imageView = owner.imageView else { return }
        
        let currentPinchScale = owner.adjust(pinchScale: gestureRecognizer.scale)
        
        switch gestureRecognizer.state {
        case .began:
            pinchCenter = CGPoint(x: gestureRecognizer.location(in: imageView).x - imageView.bounds.midX,
                                  y: gestureRecognizer.location(in: imageView).y - imageView.bounds.midY)
        case .changed:
            owner.backgroundView.alpha = owner.backgroundAlpha(for: currentPinchScale)
            currentScale = currentPinchScale
        default:
            if  currentPinchScale <= owner.minimumPinchScale ||
                currentPinchScale < owner.settings.zoomCancelingThreshold {
                dismissOverlay()
            } else {
                presentOverlay()
            }
        }
    }
    
    @objc func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        guard   let owner = owner,
                gestureRecognizer.state == .changed else { return }
        
        currentTranslation = gestureRecognizer.translation(in: owner.containerView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        owner?.log(#function, at: Loglevel.verbose)
        bypassAnimateToExpectedFrameOfScrollableImageView()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        owner?.log(#function, at: Loglevel.verbose)
        bypassAnimateToExpectedFrameOfScrollableImageView()
    }
}

//MARK: Internal Methods
internal extension ImageZoomControllerIsPresentingImageViewOverlayState {
    
    @objc func neededScrolllViewZoomScale() -> ImageScale {
        guard let owner = owner else { return 1 }
        
        return owner.zoomScale(from: owner.overlayImageView)
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsPresentingImageViewOverlayState {
    
    var fromFrame: CGRect {
        guard let overlayImageView = owner?.overlayImageView else { return CGRect.zero }
        return overlayImageView.frame
    }
    
    func updateOverlayImageViewTransform() {
        guard let owner = owner else { return }
        
        if let pinchCenter = pinchCenter {
            owner.overlayImageView.transform = CGAffineTransform.identity   .translatedBy(x: currentTranslation.x,
                                                                                          y: currentTranslation.y)
                .translatedBy(x: pinchCenter.x * (1-currentScale),
                              y: pinchCenter.y * (1-currentScale))
                .scaledBy(x: currentScale,
                          y: currentScale)
        } else {
            owner.overlayImageView.transform = CGAffineTransform.identity   .translatedBy(x: currentTranslation.x,
                                                                                          y: currentTranslation.y)
                .scaledBy(x: currentScale,
                          y: currentScale)
        }
    }
    
    /// Configures the scrollView to mimic the state of owner.overlayImageView as close as possible
    func configureScrollView() {
        guard   let owner = owner,
                let containerView = owner.containerView else { return }
        
        owner.scrollView.addSubview(owner.scrollableImageView)
        containerView.addSubview(owner.scrollView)
        owner.scrollableImageView.autoPinEdgesToSuperviewEdges()
        owner.scrollView.contentOffset = CGPoint.zero
        owner.scrollView.minimumZoomScale = owner.minimumZoomScale
        owner.scrollView.maximumZoomScale = owner.settings.maximumZoomScale
        owner.shouldAdjustScrollViewFrameAfterZooming = false
        owner.scrollView.zoomScale = neededScrolllViewZoomScale()
        owner.shouldAdjustScrollViewFrameAfterZooming = true
        owner.scrollView.contentSize = owner.overlayImageView.frame.width > owner.maximumImageSizeSize().width ?    owner.maximumImageSizeSize() :
                                                                                                                    owner.overlayImageView.frame.size
        owner.contentState = owner.neededContentState()
        owner.scrollView.frame = owner.adjustedScrollViewFrame()
        owner.scrollView.contentOffset = owner.corrected(contentOffset: calculateNeededContentOffSet())
    }
    
    /// Calculate the offset that the scrollView needs to have the absolute frame of scrollableImageView be the same as the absolute frame of overlayImageView
    func calculateNeededContentOffSet() -> CGPoint {
        guard let owner = owner else { return CGPoint.zero }
        
        let differenceBetweenNeededFrame = owner.adjustedScrollViewFrame().difference(with: fromFrame)
        if owner.zoomScale(from: owner.overlayImageView) <= owner.settings.maximumZoomScale {
            contentOffsetCorrectionDueToZoomDifference = CGPoint.zero
            neededContentOffSet = CGPoint(x: differenceBetweenNeededFrame.origin.x,
                                          y: differenceBetweenNeededFrame.origin.y)
        } else {
            let fromSize = owner.overlayImageView.frame.size
            let toSize = owner.scrollView.contentSize
            let zoomCorrection = CGPoint(x: (fromSize.width - toSize.width) / 2,
                                         y: (fromSize.height - toSize.height) / 2)
            contentOffsetCorrectionDueToZoomDifference = zoomCorrection
            neededContentOffSet = CGPoint(x: differenceBetweenNeededFrame.origin.x - zoomCorrection.x,
                                          y: differenceBetweenNeededFrame.origin.y - zoomCorrection.y)
        }
        
        return neededContentOffSet ?? CGPoint.zero
    }
    
    /// The actual absolute frame of scrollableImageView might different to the absolute frame of overlayImageView, this method calculates what the absolute frame of scrollableImageView will be
    func calculateExpectedFrameOfScrollableImageView() -> CGRect {
        guard   let owner = owner,
                let neededContentOffSet = neededContentOffSet,
                let contentOffsetCorrectionDueToZoomDifference = contentOffsetCorrectionDueToZoomDifference,
                let image = owner.imageView?.image else { return CGRect.zero }
        
        let contentOffsetCorrectionDueToScrollView = owner.contentOffsetCorrection(on: neededContentOffSet)
        expectedFrameOfScrollableImageView = CGRect(x: fromFrame.origin.x + contentOffsetCorrectionDueToScrollView.x + contentOffsetCorrectionDueToZoomDifference.x,
                                                    y: fromFrame.origin.y + contentOffsetCorrectionDueToScrollView.y + contentOffsetCorrectionDueToZoomDifference.y,
                                                    width: owner.size(of: image, at: owner.scrollView.zoomScale).width,
                                                    height: owner.size(of: image, at: owner.scrollView.zoomScale).height)
        
        return expectedFrameOfScrollableImageView ?? CGRect.zero
    }
    
    func finishPresentingOverlayImageView() {
        owner?.log(#function, at: Loglevel.verbose)
        guard let owner = owner else { return }
        
        owner.resetOverlayImageView()
        owner.state = IsPresentingScrollViewOverlayState(owner: owner)
    }
    
    func animateToExpectedFrameOfScrollableImageView(onComplete: @escaping ()->()) {
        owner?.log(#function, at: Loglevel.verbose)
        guard   let owner = owner,
                let expectedFrameOfScrollableImageView = expectedFrameOfScrollableImageView else { return }
        
        hideScrollableImageViewWhileKeepingItUserInteractable()

        owner.animator(for: .positionCorrection).animate({
            owner.overlayImageView.frame = expectedFrameOfScrollableImageView
        }) {
            guard   !self.isDismissingOverlay,
                    !self.isBypasssingAnimateToExpectedFrameOfScrollableImageView,
                    owner.state as? AnyObject === self else { return }
            
            owner.scrollableImageView.image = owner.image
            onComplete()
        }
    }
    
    func hideScrollableImageViewWhileKeepingItUserInteractable() {
        guard   let owner = owner,
                let image = owner.image else { return }
        
        owner.scrollableImageView.image = UIImage(color: .clear, size: image.size)
    }
    
    func bypassAnimateToExpectedFrameOfScrollableImageView() {
        guard let owner = owner else { return }
        
        isBypasssingAnimateToExpectedFrameOfScrollableImageView = true
        owner.scrollableImageView.image = owner.image
        finishPresentingOverlayImageView()
    }
}
