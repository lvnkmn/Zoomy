/// Can perform spring animations with different options
public struct SpringAnimator {
    
    // MARK: Public properties
    public let duration: TimeInterval
    public let delay: TimeInterval
    public let springDamping: CGFloat
    public let initialSpringVelocity: CGFloat
    public let options: UIViewAnimationOptions
    
    // MARK: Initializers
    public init(duration: TimeInterval = 0.5,
         delay: TimeInterval = 0,
         springDamping: CGFloat = 0.66,
         initialSpringVelocity: CGFloat = 0.5,
         options: UIViewAnimationOptions = []) {
        self.duration = duration
        self.delay = delay
        self.springDamping = springDamping
        self.initialSpringVelocity = initialSpringVelocity
        self.options = options
    }
}

extension SpringAnimator: CanAnimate {
    public func animate(_ animations: @escaping () -> (), completion: (() -> ())?) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: initialSpringVelocity,
                       options: options,
                       animations: animations) { _ in
                        completion?()
        }
    }
}
