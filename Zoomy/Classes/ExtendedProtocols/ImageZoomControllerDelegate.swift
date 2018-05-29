import Foundation

public protocol ImageZoomControllerDelegate: class {

    func didBeginPresentingOverlay(for imageView: UIImageView)
    func didEndPresentingOverlay(for imageView: UIImageView)
    func willDismissOverlay()
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState)
    func animator(for event: AnimationEvent) -> CanAnimate?
}

public extension ImageZoomControllerDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {}
    func didEndPresentingOverlay(for imageView: UIImageView) {}
    func willDismissOverlay() {}
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {}
    func animator(for event: AnimationEvent) -> CanAnimate? {
        return nil
    }
}
