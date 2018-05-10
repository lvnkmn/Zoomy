public struct DefaultAnimators {
    
    var backgroundColorAnimator: CanAnimate = Animator(duration: 0.5, options: .curveLinear)
    
    var dismissalAnimator: CanAnimate = Animator(duration: 0.2, options: .curveEaseInOut)
    
    var positionCorrectionAnimator: CanAnimate = SpringAnimator()
    
    public init() {}
}

extension DefaultAnimators: CanProvideAnimatorForEvent {
    
    public func animator(for event: AnimationEvent) -> CanAnimate {
        switch event {
        case .backgroundColorChange:
            return backgroundColorAnimator
        case .overlayDismissal:
            return dismissalAnimator
        case .positionCorrection:
            return positionCorrectionAnimator
        }
    }
}

public extension DefaultAnimators {
    
    func with(backgroundColorAnimator: CanAnimate) -> DefaultAnimators {
        var animators = self
        animators.backgroundColorAnimator = backgroundColorAnimator
        return animators
    }
    
    func with(dismissalAnimator: CanAnimate) -> DefaultAnimators {
        var animators = self
        animators.dismissalAnimator = dismissalAnimator
        return animators
    }
    
    func with(positionCorrectionAnimator: CanAnimate) -> DefaultAnimators {
        var animators = self
        animators.positionCorrectionAnimator = positionCorrectionAnimator
        return animators
    }
}
