internal protocol ImageZoomControllerState: class {
    func presentOverlay()
    func dismissOverlay()
    func didPan(with gestureRecognizer: UIPanGestureRecognizer)
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
}

internal extension ImageZoomControllerState {

    func presentOverlay() {}
    func dismissOverlay() {}
    func didPan(with gestureRecognizer: UIPanGestureRecognizer) {}
    func didPinch(with gestureRecognizer: UIPinchGestureRecognizer) {}
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {}
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {}
}
