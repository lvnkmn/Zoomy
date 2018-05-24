public class ImageZoomControllerAction: CustomStringConvertible {
    public var description: String {
        return "Action"
    }
    
    public init() {}
    
    /// Causes the overlay to be dismissed
    public static var dismissOverlay: DismissOverlay {
        return DismissOverlay()
    }
    
    /// Causes the image to be zoomed until it fit's its container
    public static var zoomToFit: ZoomToFit {
        return ZoomToFit()
    }
    
    /// Causes the image to be zoomed all the way in
    public static var zoomIn: ZoomIn {
        return ZoomIn()
    }
    
    /// Does nothing
    public  static var none: None {
        return None()
    }
    
    public static var all: [Action] {
        return [Action.none, Action.zoomToFit, Action.zoomIn, Action.dismissOverlay]
    }
}

public extension ImageZoomControllerAction {
    
    /// Does nothing
    public final class None:    ImageZoomControllerAction,
                                CanBeTriggeredByAnyInteraction{
        override public var description: String {
            return "None"
        }
    }
    
}

public extension ImageZoomControllerAction {
    /// Causes the image to be zoomed until it fit's its container
    public final class ZoomToFit:   ImageZoomControllerAction,
                                    CanBeTriggeredByImageViewTap,
                                    CanBeTriggeredByImageViewDoubleTap,
                                    CanBeTriggeredByOverlayTap {
        override public var description: String {
            return "ZoomToFit"
        }
    }
}

public extension ImageZoomControllerAction {
    /// Causes the image to be zoomed all the way in
    public final class ZoomIn:  ImageZoomControllerAction,
                                CanBeTriggeredByImageViewTap,
                                CanBeTriggeredByImageViewDoubleTap,
                                CanBeTriggeredByOverlayTap,
                                CanBeTriggeredByOverlayDoubleTap {
        override public var description: String {
            return "ZoomIn"
        }
    }
}

public extension ImageZoomControllerAction {
    /// Causes the overlay to be dismissed
    public final class DismissOverlay:  ImageZoomControllerAction,
                                        CanBeTriggeredByOverlayTap,
                                        CanBeTriggeredByOverlayDoubleTap,
                                        CanBeTriggeredByScrollBounceTop,
                                        CanBeTriggeredByScrollBounceLeft,
                                        CanBeTriggeredByBackgroundViewTap,
                                        CanBeTriggeredByBackgroundDoubleTap,
                                        CanBeTriggeredByScrollBounceRight,
                                        CanBeTriggeredByScrollBounceBottom {
        override public var description: String {
            return "Dismiss"
        }
    }
}
