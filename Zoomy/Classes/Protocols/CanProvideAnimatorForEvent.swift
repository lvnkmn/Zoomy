public protocol CanProvideAnimatorForEvent {
    
    func animator(for event: AnimationEvent) -> CanAnimate
}
