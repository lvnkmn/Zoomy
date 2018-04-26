public struct DefaultAnimators {
    
    var backgroundColorAnimator: CanAnimate = Animator(duration: 0.5, options: .curveLinear)
    
    var dismissalAnimator: CanAnimate = Animator(duration: 0.2, options: .curveEaseInOut)
    
    var positionCorrectionAnimator: CanAnimate = SpringAnimator()
}

extension DefaultAnimators: CanProvideAnimatorForEvent {
    
    public func animator(for event: AnimationEvent) -> CanAnimate {
        switch event {
        case .BackgroundColorChange:
            return backgroundColorAnimator
        case .OverlayDismissal:
            return dismissalAnimator
        case .PositionCorrection:
            return positionCorrectionAnimator
        }
    }
}
