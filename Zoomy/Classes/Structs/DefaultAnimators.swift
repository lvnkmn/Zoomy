public struct DefaultAnimators {
    
    var backgroundColorAnimator: CanAnimate = Animator(duration: 0.5, options: .curveLinear)
    
    var dismissalAnimator: CanAnimate = Animator(duration: 0.2, options: .curveEaseInOut)
    
    var positionCorrectionAnimator: CanAnimate = SpringAnimator()
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
