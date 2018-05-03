/// Can perform animations with different options
public struct Animator {
    
    // MARK: Public properties
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let options: UIViewAnimationOptions
    
    // MARK: Initializers
    public init(duration: TimeInterval = 0.5, delay: TimeInterval = 0, options: UIViewAnimationOptions = .curveEaseInOut) {
        self.duration = duration
        self.delay = delay
        self.options = options
    }
}

extension Animator: CanAnimate {
    public func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: options,
                       animations: animations) { _ in
                        completion?()
        }
    }
}
