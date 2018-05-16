public enum AnimationEvent {
    case overlayDismissal
    case positionCorrection
    case backgroundColorChange
    case zoom
}

public extension AnimationEvent {
    
    static var all: [AnimationEvent] {
        return [.overlayDismissal, .positionCorrection, .backgroundColorChange]
    }
}
