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
    internal private (set) var isDismissingOverlay = false {
        didSet {
            logger.log(isDismissingOverlay, atLevel: .verbose)
        }
    }
    
    private lazy var fromFrame: CGRect = owner?.overlayImageView.frame ?? CGRect.zero
    
    private var neededContentOffSet: CGPoint?
    private var contentOffsetCorrectionDueToZoomDifference: CGPoint?
    private var expectedFrameOfScrollableImageView: CGRect?
    
    private var isBypasssingAnimateToExpectedFrameOfScrollableImageView = false {
        didSet {
            logger.log(isBypasssingAnimateToExpectedFrameOfScrollableImageView, atLevel: .verbose)
        }
    }
    
    private var scaleCenter: CGPoint?
    
    // MARK: Initializers
    init(owner: ImageZoomController) {
        self.owner = owner
    }
}

//MARK: ImageZoomControllerState
extension ImageZoomControllerIsPresentingImageViewOverlayState: ImageZoomControllerState {
    
    func presentOverlay() {
        presentOverlay(event: .positionCorrection)
    }
    
    func presentOverlay(event: AnimationEvent) {
        logger.log(atLevel: .verbose)
        guard let owner = owner else { return }
        
        configureScrollView()
        
        if owner.overlayImageView.frame == calculateExpectedFrameOfScrollableImageView() {
            finishPresentingOverlayImageView()
        } else {
            animateToExpectedFrameOfScrollableImageView(event: event, onComplete: finishPresentingOverlayImageView)
        }
    }
    
    func zoomToFit() {
        logger.log(atLevel: .verbose)
        guard let owner = owner else { return }
        
        fromFrame = containerFittingFrame(for: owner.overlayImageView)
        presentOverlay()
    }
    
    func zoomIn(with gestureRecognizer: UIGestureRecognizer?) {
        logger.log(atLevel: .verbose)
        guard   let owner = owner,
                let absoluteFrameOfImageView = owner.initialAbsoluteFrameOfImageView  else { return }
        
        fromFrame = absoluteFrameOfImageView.transformedBy(.transform(withScale: owner.pinchScale(from: owner.settings.maximumZoomScale),
                                                                      center: scaleCenter(from: gestureRecognizer)))

        presentOverlay(event: .zoom)
    }
    
    func dismissOverlay() {
        logger.log(atLevel: .verbose)
        guard   let owner = owner,
                let imageView = owner.imageView,
                let absoluteFrameOfImageView = owner.initialAbsoluteFrameOfImageView else { return }
        
        owner.delegate?.willDismissOverlay()
        isDismissingOverlay = true
        owner.scrollView.removeFromSuperview()
        
        owner.animator(for: .overlayDismissal).animate({
            owner.overlayImageView.frame = absoluteFrameOfImageView
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
        guard   let owner = owner else { return }
        
        let currentPinchScale = owner.adjust(pinchScale: gestureRecognizer.scale)
        
        switch gestureRecognizer.state {
        case .began:
            scaleCenter = scaleCenter(from: gestureRecognizer)
        case .changed:
            owner.backgroundView.alpha = backgroundAlpha(for: currentPinchScale)
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
        logger.log(atLevel: .verbose)
        bypassAnimateToExpectedFrameOfScrollableImageView()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        logger.log(atLevel: .verbose)
        bypassAnimateToExpectedFrameOfScrollableImageView()
    }
}

//MARK: Internal Methods
internal extension ImageZoomControllerIsPresentingImageViewOverlayState {
    
    @objc func neededScrolllViewZoomScale() -> ImageScale {
        guard let image = owner?.image else { return 1 }
        return fromFrame.size.width / image.size.width
    }
}

//MARK: Private Methods
private extension ImageZoomControllerIsPresentingImageViewOverlayState {
    
    func updateOverlayImageViewTransform() {
        guard let owner = owner else { return }
        
        if let scaleCenter = scaleCenter {
            owner.overlayImageView.transform = .transform(withScale: currentScale, translation: currentTranslation, center: scaleCenter)
        } else {
            owner.overlayImageView.transform = .transform(withScale: currentScale, translation: currentTranslation)
        }
    }
    
    /// Configures the scrollView to mimic the state of owner.overlayImageView as close as possible
    func configureScrollView() {
        guard   let owner = owner,
                let containerView = owner.containerView else { return }
        
        owner.scrollView.addSubview(owner.scrollableImageView)
        
        if let topmostView = owner.topmostView {
            containerView.insertSubview(owner.scrollView, belowSubview: topmostView)
        } else {
            containerView.addSubview(owner.scrollView)
        }
        
        owner.scrollableImageView.pinEdgesToSuperviewEdges()
        owner.scrollView.contentOffset = CGPoint.zero
        owner.scrollView.minimumZoomScale = owner.minimumZoomScale
        owner.scrollView.maximumZoomScale = owner.settings.maximumZoomScale
        owner.shouldAdjustScrollViewFrameAfterZooming = false
        owner.scrollView.zoomScale = neededScrolllViewZoomScale()
        owner.shouldAdjustScrollViewFrameAfterZooming = true
        owner.scrollView.contentSize = fromFrame.width > owner.maximumImageSize().width ?   owner.maximumImageSize() :
                                                                                            fromFrame.size
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
        logger.log(atLevel: .verbose)
        guard let owner = owner else { return }
        
        owner.scrollView.pinchGestureRecognizer?.isEnabled = true
        owner.resetOverlayImageView()
        owner.state = IsPresentingScrollViewOverlayState(owner: owner)
    }
    
    func animateToExpectedFrameOfScrollableImageView(event: AnimationEvent, onComplete: @escaping ()->()) {
        logger.log(atLevel: .verbose)
        guard   let owner = owner,
                let expectedFrameOfScrollableImageView = expectedFrameOfScrollableImageView,
                let neededContentMode = owner.imageView?.contentMode else { return }
        
        owner.scrollView.pinchGestureRecognizer?.isEnabled = false
        hideScrollableImageViewWhileKeepingItUserInteractable()

        owner.animator(for: event).animate({
            owner.overlayImageView.frame = expectedFrameOfScrollableImageView
        }) {
            guard   !self.isDismissingOverlay,
                    !self.isBypasssingAnimateToExpectedFrameOfScrollableImageView,
                    owner.state === self else { return }
            
            owner.scrollView.pinchGestureRecognizer?.isEnabled = true
            owner.scrollableImageView.image = owner.image
            owner.scrollableImageView.contentMode = neededContentMode
            onComplete()
        }
    }
    
    func hideScrollableImageViewWhileKeepingItUserInteractable() {
        guard   let owner = owner,
                let image = owner.image else { return }
        
        owner.scrollableImageView.image = UIImage(color: .clear, size: image.size)
    }
    
    func bypassAnimateToExpectedFrameOfScrollableImageView() {
        guard   let owner = owner,
                let neededContentMode = owner.imageView?.contentMode else { return }
        
        isBypasssingAnimateToExpectedFrameOfScrollableImageView = true
        owner.scrollableImageView.image = owner.image
        owner.scrollableImageView.contentMode = neededContentMode
        finishPresentingOverlayImageView()
    }
    
    func backgroundAlpha(for pinchScale: ImageViewScale) -> CGFloat {
        guard let owner = owner else { return 0 }
        let delta = owner.settings.primaryBackgroundColorThreshold - owner.minimumPinchScale
        let progress = pinchScale - owner.minimumPinchScale
        return max(min(progress/delta, 1), 0)
    }
    
    func containerFittingFrame(for overlayImageView: UIImageView) -> CGRect {
        guard let containerViewSize = owner?.containerView?.frame.size else { return CGRect.zero }
        let overlayImageViewSize = overlayImageView.frame.size
        
        let neededWidthIncrease = containerViewSize.width - overlayImageViewSize.width
        let neededHeightIncrease = containerViewSize.height - overlayImageViewSize.height
        
        let zoomScale: CGFloat
        if neededWidthIncrease < neededHeightIncrease {
            zoomScale = containerViewSize.width / overlayImageViewSize.width
        } else {
            zoomScale = containerViewSize.height / overlayImageViewSize.height
        }
        
        return CGRect(x: 0,
                      y: overlayImageView.frame.origin.y,
                      width: overlayImageViewSize.width * zoomScale,
                      height: overlayImageViewSize.height * zoomScale)
    }
    
    func adjustedImageOverlayViewFrame(neededSize: CGSize) -> CGRect {
        guard   let initialAbsoluteFrameOfImageView = owner?.initialAbsoluteFrameOfImageView else { return CGRect.zero }
        
        let originX = max(initialAbsoluteFrameOfImageView.origin.x - (neededSize.width - initialAbsoluteFrameOfImageView.size.width) / 2, 0)
        let originY = max(initialAbsoluteFrameOfImageView.origin.y - (neededSize.height - initialAbsoluteFrameOfImageView.size.height) / 2, 0)
        
        return CGRect(x: originX,
                      y: originY,
                      width: neededSize.width,
                      height: neededSize.height)
    }
    
    func scaleCenter(from gestureRecognizer: UIGestureRecognizer?) -> CGPoint {
        guard   let gestureRecognizer = gestureRecognizer,
                let imageView = owner?.imageView else { return CGPoint.zero }
        return CGPoint(x: gestureRecognizer.location(in: imageView).x - imageView.bounds.midX,
                       y: gestureRecognizer.location(in: imageView).y - imageView.bounds.midY)
    }
}
