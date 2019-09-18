import UIKit

internal protocol ImageZoomControllerState: class {
    func presentOverlay()
    func dismissOverlay()
    func zoomToFit()
    func zoomIn(with gestureRecognizer: UIGestureRecognizer?)
    func didPan(with gestureRecognizer: UIPanGestureRecognizer)
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    func scrollViewDidZoom(_ scrollView: UIScrollView)
}

internal extension ImageZoomControllerState {

    func presentOverlay() {}
    func dismissOverlay() {}
    func zoomToFit() {}
    func zoomIn(with gestureRecognizer: UIGestureRecognizer?) {}
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {}
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {}
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {}
    func scrollViewDidZoom(_ scrollView: UIScrollView) {}
}
