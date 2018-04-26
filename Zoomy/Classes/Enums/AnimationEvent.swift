public enum AnimationEvent {
    case OverlayDismissal
    case PositionCorrection
    case BackgroundColorChange
}

public extension AnimationEvent {
    
    static var all: [AnimationEvent] {
        return [.OverlayDismissal, .PositionCorrection, .BackgroundColorChange]
    }
}
