//  Created by Menno on 21/03/2018.
//

import Foundation
import PureLayout

public class ImageZoomController: NSObject {
    // MARK: Public Properties
    
    /// Gets callbacks on important events in the ImageZoomController's lifeCycle
    public weak var delegate: ImageZoomControllerDelegate?
    
    public var settings: ImageZoomControllerSettings
    
    /// View in which zoom will take place
    weak public private(set) var containerView: UIView?
    
    /// The imageView that is to be the source of the zoom interactions
    weak public private(set) var imageView: UIImageView?
    
    /// When zoom gesture ends while currentZoomScale is below minimumZoomScale, the overlay will be dismissed
    public private(set) lazy var minimumZoomScale = zoomScale(from: imageView)
    
    // MARK: Fileprivate Properties
    fileprivate lazy var scrollableImageView = createScrollableImageView()
    fileprivate lazy var overlayImageView = createOverlayImageView()
    fileprivate lazy var scrollView = createScrollView()
    fileprivate lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = settings.primaryBackgroundColor
        return view
    }()

    fileprivate lazy var state: ImageZoomControllerState = IsNotPresentingOverlayState(owner: self)
    
    fileprivate var contentState = ImageZoomControllerContentState.smallerThanAnsestorView {
        didSet {
            guard contentState != oldValue else { return }

            animate {
                self.backgroundView.backgroundColor = self.backgroundColor(for: self.contentState)
            }
            delegate?.contentStateDidChange(from: oldValue, to: contentState)
        }
    }
    
    fileprivate var pinchCenter: CGPoint?
    fileprivate var originalOverlayImageViewCenter: CGPoint?
    fileprivate var shouldAdjustScrollViewFrameAfterZooming = true
    
    // MARK: Private Properties
    
    private lazy var imageViewPinchGestureRecognizer: UIPinchGestureRecognizer = {
        let gestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(with:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    private lazy var imageViewPanGestureRecognizer: UIPanGestureRecognizer = {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(with:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    private lazy var scrollableImageViewTapGestureRecognizer: UITapGestureRecognizer = {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapScrollableImageView(with:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer
    }()
    
    /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
    private var minimumPinchScale: ImageViewScale {
        return pinchScale(from: minimumZoomScale)
    }
    
    /// the scale is applied on the imageView where a scale of 1 results in the orinal imageView's size
    private var maximumPinchScale: ImageViewScale {
        return pinchScale(from: settings.maximumZoomScale)
    }
    
    // MARK: Initializers
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - delegate: delegate
    ///   - settings: mutable settings that will be applied on this ImageZoomController
    public required init(container containerView: UIView,
                         imageView: UIImageView,
                         delegate: ImageZoomControllerDelegate?,
                         settings: ImageZoomControllerSettings) {
        self.containerView = containerView
        self.imageView = imageView
        self.delegate = delegate
        self.settings = settings
        
        super.init()
        
        configureImageView()
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    public convenience init(container containerView: UIView, imageView: UIImageView) {
        self.init(container: containerView, imageView: imageView, delegate: nil, settings: .defaultSettings)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - delegate: delegate
    public convenience init(container containerView: UIView, imageView: UIImageView, delegate: ImageZoomControllerDelegate) {
        self.init(container: containerView, imageView: imageView, delegate: delegate, settings: .defaultSettings)
    }
    
    /// Initializer
    ///
    /// - Parameters:
    ///   - container: view in which zoom will take place, has to be an ansestor of imageView
    ///   - imageView: the imageView that is to be the source of the zoom interactions
    ///   - settings: mutable settings that will be applied on this ImageZoomController
    public convenience init(container containerView: UIView, imageView: UIImageView, settings: ImageZoomControllerSettings) {
        self.init(container: containerView, imageView: imageView, delegate: nil, settings: settings)
    }
    
    // MARK: Deinitalizer
    deinit {
        imageView?.removeGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewPanGestureRecognizer)
    }
}

//MARK: Public methods
public extension ImageZoomController {
    
    /// Dismiss all currently presented overlays
    public func dismissOverlay() {
        state.dismissOverlay()
    }
    
    /// Reset imageView and viewHierarchy to the state prior to initializing the zoomControlelr
    func reset() {
        imageView?.removeGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.removeGestureRecognizer(imageViewPanGestureRecognizer)
        imageView?.alpha = 1
        
        overlayImageView.removeFromSuperview()
        overlayImageView = createOverlayImageView()
        scrollableImageView.removeFromSuperview()
        scrollableImageView = createScrollableImageView()
        scrollView.removeFromSuperview()
        scrollView = createScrollView()
        
        if settings.shouldDisplayBackground {
            backgroundView.removeFromSuperview()
        }
        
        state = IsNotPresentingOverlayState(owner: self)
    }
}

//MARK: Gesture Event Handlers
private extension ImageZoomController {
    
    @objc func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {
        guard   let imageView = imageView,
                settings.isEnabled else { return }
        
        let currentPinchScale = adjust(pinchScale: gestureRecognizer.scale)
        if  gestureRecognizer.state == .began {
            state.presentOverlay()
            pinchCenter = CGPoint(x: gestureRecognizer.location(in: imageView).x - imageView.bounds.midX,
                                  y: gestureRecognizer.location(in: imageView).y - imageView.bounds.midY)
        } else if gestureRecognizer.state == .changed {
            guard let pinchCenter = pinchCenter else { return }
            backgroundView.alpha = backgroundAlpha(for: currentPinchScale)
            overlayImageView.transform = CGAffineTransform.identity .translatedBy(x: pinchCenter.x * (1-currentPinchScale),
                                                                                  y: pinchCenter.y * (1-currentPinchScale))
                                                                    .scaledBy(x: currentPinchScale,
                                                                              y: currentPinchScale)
        } else {
            if currentPinchScale <= minimumPinchScale || currentPinchScale < settings.zoomCancelingThreshold {
                state.dismissOverlay()
            } else {
                state.presentOverlay()
            }
        }
    }
    
    @objc func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        state.didPan(with: gestureRecognizer)
    }
    
    @objc func didTapScrollableImageView(with gestureRecognizer: UITapGestureRecognizer) {
        state.dismissOverlay()
    }
    
    @objc func didTapOverlayImageView(with gestureRecognizer: UITapGestureRecognizer) {
        state.dismissOverlay()
    }
}

//MARK: Setup
private extension ImageZoomController {
    
    func createScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.clipsToBounds = false
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = true
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = true
        return view
    }
    
    func createScrollableImageView() -> UIImageView {
        let view = UIImageView()
        view.addGestureRecognizer(scrollableImageViewTapGestureRecognizer)
        view.isUserInteractionEnabled = true
        view.image = imageView?.image
        return view
    }
    
    func createOverlayImageView() -> UIImageView {
        let view = UIImageView()
        view.image = imageView?.image
        return view
    }
    
    func configureImageView() {
        imageView?.addGestureRecognizer(imageViewPinchGestureRecognizer)
        imageView?.addGestureRecognizer(imageViewPanGestureRecognizer)
        imageView?.isUserInteractionEnabled = true
    }
}

//MARK: Calculations
private extension ImageZoomController {
    
    func adjustedScrollViewFrame() -> CGRect {
        guard let view = containerView else { return CGRect.zero }
        
        let minimalScrollViewFrame = absoluteFrame(of: imageView)
        let originX = max(minimalScrollViewFrame.origin.x - (scrollView.contentSize.width - minimalScrollViewFrame.width) / 2, 0)
        let originY = max(minimalScrollViewFrame.origin.y - (scrollView.contentSize.height - minimalScrollViewFrame.height) / 2, 0)
        let width = min(scrollView.contentSize.width, view.frame.width)
        let height = min(scrollView.contentSize.height, view.frame.height)
        
        return CGRect(x: originX,
                      y: originY,
                      width: width,
                      height: height)
    }
    
    /// Shows how much the provided content offset will be corrected if applied to the scrollView
    ///
    /// - Parameter contentOffset: the contentOffset
    /// - Returns: the correction
    func contentOffsetCorrection(on contentOffset: CGPoint) -> CGPoint {
        let x: CGFloat
        if contentOffset.x < 0 {
            x = contentOffset.x
        } else if contentOffset.x - (scrollView.contentSize.width - scrollView.frame.size.width) > 0 {
            x = contentOffset.x - (scrollView.contentSize.width - scrollView.frame.size.width)
        } else {
            x = 0
        }
        
        let y: CGFloat
        if contentOffset.y + adjustedContentInset(from: scrollView).top < 0 {
            y = contentOffset.y + adjustedContentInset(from: scrollView).top
        } else if contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height + adjustedContentInset(from: scrollView).bottom) > 0 {
            y = contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height + adjustedContentInset(from: scrollView).bottom)
        } else {
            y = 0
        }
        
        return CGPoint(x: x, y: y)
    }
    
    /// Returns what the provided contentOffset will turn into when applied on the scrollView
    ///
    /// - Parameter contentOffset: contentOffset
    /// - Returns: corrected contentOffset
    func corrected(contentOffset: CGPoint) -> CGPoint {
        let correction = contentOffsetCorrection(on: contentOffset)
        return CGPoint(x: contentOffset.x - correction.x,
                       y: contentOffset.y - correction.y)
    }

    func zoomScale(from imageView: UIImageView?) -> ImageScale {
        guard   let imageView = imageView,
                let image = imageView.image else { return 1 }
        return imageView.frame.size.width / image.size.width
    }
    
    func pinchScale(from zoomScale: ImageScale) -> ImageViewScale {
        return zoomScale / minimumZoomScale
    }
    
    /// Adds the bounce like behavior to the provided pinchScale
    ///
    /// - Parameter pinchScale: pinchScale
    /// - Returns: pinchScale
    func adjust(pinchScale: ImageViewScale) -> ImageViewScale {
        guard   pinchScale < minimumPinchScale ||
                pinchScale > maximumPinchScale else { return pinchScale }
 
        let bounceScale = sqrt(3)
        let x: ImageViewScale
        let k: ImageViewScale
        if pinchScale < minimumPinchScale {
            x = pinchScale / minimumPinchScale
            k = ImageViewScale(1/bounceScale)
            return minimumPinchScale * ((2 * k - 1) * pow(x, 3) + (2 - 3 * k) * pow(x, 2) + k)
        } else { // pinchScale > maximumPinchScale
            x = pinchScale / maximumPinchScale
            k = ImageViewScale(bounceScale)
            return maximumPinchScale * ((2 * k - 2) / (1 + exp(4 / k * (1 - x))) - k + 2)
        }
    }
    
    func absoluteFrame(of subjectView: UIView?) -> CGRect {
        guard   let subjectView = subjectView,
                let view = containerView else { return CGRect.zero }
        
        return view.convert(subjectView.frame, from: subjectView.superview)
    }
    
    func maximumImageSizeSize() -> CGSize {
        guard let imageView = imageView else { return CGSize.zero }
        let view = UIView()
        view.frame = imageView.frame
        view.transform = view.transform.scaledBy(x: maximumPinchScale, y: maximumPinchScale)
        return view.frame.size
    }
    
    func adjustedContentInset(from scrollView: UIScrollView) -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return scrollView.adjustedContentInset
        } else {
            return scrollView.contentInset
        }
    }
    
    func backgroundAlpha(for pinchScale: ImageViewScale) -> CGFloat {
        let delta = settings.zoomCancelingThreshold - minimumPinchScale
        let progress = pinchScale - minimumPinchScale
        return max(min(progress/delta, 1), 0)
    }
    
    func imageDoesntFitScreen() -> Bool {
        guard let view = containerView else { return false }
        return scrollView.contentSize.width > view.frame.size.width
    }
}

//MARK: Other
private extension ImageZoomController {
    
    func adjustFrame(of scrollView: UIScrollView) {
        let oldScrollViewFrame = scrollView.frame
        scrollView.frame = adjustedScrollViewFrame()
        let frameDifference = scrollView.frame.difference(with: oldScrollViewFrame)
        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + frameDifference.origin.x,
                                           y: scrollView.contentOffset.y + frameDifference.origin.y)
    }
    
    func backgroundColor(for state: ImageZoomControllerContentState) -> UIColor {
        switch state {
        case .smallerThanAnsestorView:
            return settings.primaryBackgroundColor
        case .fillsAnsestorView:
            return settings.secundaryBackgroundColor
        }
    }
    
    func neededContentState() -> ImageZoomControllerContentState {
        guard let view = containerView else { return .smallerThanAnsestorView }
        return  scrollView.contentSize.width >= view.frame.size.width ||
                scrollView.contentSize.height >= view.frame.size.height ?   .fillsAnsestorView :
                                                                            .smallerThanAnsestorView
    }
}

// MARK: UIScrollViewDelegate
extension ImageZoomController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollableImageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if shouldAdjustScrollViewFrameAfterZooming {
            adjustFrame(of: scrollView)
        }
        
        contentState = neededContentState()
    }
    
    public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        state.scrollViewWillBeginZooming(scrollView, with: view)
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scrollView.zoomScale <= minimumZoomScale {
            state.dismissOverlay()
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        state.scrollViewWillBeginDragging(scrollView)
    }
}

//MARK: UIGestureRecognizerDelegate
extension ImageZoomController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

//MARK: - States
private protocol ImageZoomControllerState {
    func presentOverlay()
    func dismissOverlay()
    func didPan(with gestureRecognizer: UIPanGestureRecognizer)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
}

private extension ImageZoomControllerState {
    
    func presentOverlay() {}
    func dismissOverlay() {}
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {}
}

private struct IsNotPresentingOverlayState: ImageZoomControllerState {
    
    weak var owner: ImageZoomController?
    
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
}

private class IsPresentingImageViewOverlayState: ImageZoomControllerState {
    
    weak var owner: ImageZoomController?
    var isDismissingOverlay = false
    
    private var neededContentOffSet: CGPoint?
    private var contentOffsetCorrectionDueToZoomDifference: CGPoint?
    private var expectedFrameOfScrollableImageView: CGRect?
    private var isBypasssingAnimateToExpectedFrameOfScrollableImageView = false
    
    init(owner: ImageZoomController) {
        self.owner = owner
    }
    
    func presentOverlay() {
        guard let owner = owner else { return }
        
        configureScrollView()
        
        if owner.overlayImageView.frame == calculateExpectedFrameOfScrollableImageView() {
            finishPresentingOverlayImageView()
        } else {
            animateToExpectedFrameOfScrollableImageView(onComplete: finishPresentingOverlayImageView)
        }
    }
    
    func dismissOverlay() {
        guard   let owner = owner,
                let imageView = owner.imageView else { return }
        
        isDismissingOverlay = true
        owner.scrollView.removeFromSuperview()
        
        animateSpring(withAnimations: {
            owner.overlayImageView.transform = CGAffineTransform.identity
            if let originalOverlayImageViewCenter = owner.originalOverlayImageViewCenter {
                owner.overlayImageView.center = originalOverlayImageViewCenter
            }
        }) { _ in
            owner.originalOverlayImageViewCenter = nil
            owner.pinchCenter = nil
            owner.reset()
            owner.configureImageView()
            self.isDismissingOverlay = false
            owner.delegate?.didEndPresentingOverlay(for: imageView)
        }
        
        if owner.settings.shouldDisplayBackground {
            animate {
                owner.backgroundView.alpha = 0
            }
        }
    }
    
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {
        guard   let owner = owner,
                owner.settings.isEnabled,
                let view = owner.containerView else { return }
        
        if gestureRecognizer.state == .began {
            owner.originalOverlayImageViewCenter = owner.overlayImageView.center
        } else if gestureRecognizer.state == .changed {
            guard let originalOverlayImageViewCenter = owner.originalOverlayImageViewCenter else { return }
            let translation = gestureRecognizer.translation(in: view)
            owner.overlayImageView.center = CGPoint(x: originalOverlayImageViewCenter.x + translation.x,
                                                    y: originalOverlayImageViewCenter.y + translation.y)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bypassAnimateToExpectedFrameOfScrollableImageView()
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
       bypassAnimateToExpectedFrameOfScrollableImageView()
    }
}

private extension IsPresentingImageViewOverlayState {
    
    var fromFrame: CGRect {
        guard let overlayImageView = owner?.overlayImageView else { return CGRect.zero }
        return overlayImageView.frame
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
        owner.scrollView.zoomScale = owner.zoomScale(from: owner.overlayImageView)
        owner.shouldAdjustScrollViewFrameAfterZooming = true
        owner.scrollView.contentSize = owner.overlayImageView.frame.width > owner.maximumImageSizeSize().width ? owner.maximumImageSizeSize() : owner.overlayImageView.frame.size
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
                let contentOffsetCorrectionDueToZoomDifference = contentOffsetCorrectionDueToZoomDifference else { return CGRect.zero }
        
        let contentOffsetCorrectionDueToScrollView = owner.contentOffsetCorrection(on: neededContentOffSet)
        expectedFrameOfScrollableImageView = CGRect(x: fromFrame.origin.x + contentOffsetCorrectionDueToScrollView.x + contentOffsetCorrectionDueToZoomDifference.x,
                                                    y: fromFrame.origin.y + contentOffsetCorrectionDueToScrollView.y + contentOffsetCorrectionDueToZoomDifference.y,
                                                    width: owner.scrollView.contentSize.width,
                                                    height: owner.scrollView.contentSize.height)
        
        return expectedFrameOfScrollableImageView ?? CGRect.zero
    }
    
    func finishPresentingOverlayImageView() {
        guard let owner = owner else { return }
        
        owner.overlayImageView.removeFromSuperview()
        owner.state = IsPresentingScrollViewOverlayState(owner: owner)
    }
    
    func animateToExpectedFrameOfScrollableImageView(onComplete: @escaping ()->()) {
        guard   let owner = owner,
                let expectedFrameOfScrollableImageView = expectedFrameOfScrollableImageView else { return }
        
        hideScrollableImageViewWhileKeepingItUserInteractable()
        animateSpring(withAnimations: {
            owner.overlayImageView.frame = expectedFrameOfScrollableImageView
        }) { _ in
            guard   !self.isDismissingOverlay,
                    !self.isBypasssingAnimateToExpectedFrameOfScrollableImageView else { return }
            
            owner.scrollableImageView.image = owner.imageView?.image
            onComplete()
        }
    }
    
    func hideScrollableImageViewWhileKeepingItUserInteractable() {
        guard let owner = owner else { return }
        owner.scrollableImageView.image = UIImage(color: .clear, size: owner.scrollView.contentSize)
    }
    
    func bypassAnimateToExpectedFrameOfScrollableImageView() {
        guard let owner = owner else { return }
        
        isBypasssingAnimateToExpectedFrameOfScrollableImageView = true
        owner.scrollableImageView.image = owner.imageView?.image
        finishPresentingOverlayImageView()
    }
}

private struct IsPresentingScrollViewOverlayState: ImageZoomControllerState {
    
    weak var owner: ImageZoomController?
    
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
    
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {}
}
