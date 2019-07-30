extension UIGestureRecognizer.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began:
            return "began"
        case .changed:
            return "changed"
        case .cancelled:
            return "canceled"
        case .ended:
            return "ended"
        case .failed:
            return "failed"
        case .possible:
            return "possible"
        @unknown default:
            logger.logError("Unexpected gesture case")
            return "unkown"
        }
    }
}
