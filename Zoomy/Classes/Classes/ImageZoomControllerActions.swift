public class ImageZoomControllerAction {
    /// Causes the overlay to be dismissed
    public static var dismissOverlay: DismissOverlay {
        return DismissOverlay()
    }
    
    /// Causes the image to be zoomed until it fit's its container
    public static var zoomToFit: ZoomToFit {
        return ZoomToFit()
    }
    
    /// Does nothing
    public  static var none: None {
        return None()
    }
}

public extension ImageZoomControllerAction {
    /// Does nothing
    public final class None:    ImageZoomControllerAction,
                                CanBeTriggeredByAnyInteraction{}
    
}

public extension ImageZoomControllerAction {
    /// Causes the image to be zoomed until it fit's its container
    public final class ZoomToFit:   ImageZoomControllerAction,
                                    CanBeTriggeredByImageViewTap,
                                    CanBeTriggeredByImageViewDoubleTap,
                                    CanBeTriggeredByOverlayTap {}
}

public extension ImageZoomControllerAction {
    /// Causes the overlay to be dismissed
    public final class DismissOverlay:  ImageZoomControllerAction,
                                        CanBeTriggeredByOverlayTap,
                                        CanBeTriggeredByScrollBounceTop,
                                        CanBeTriggeredByScrollBounceLeft,
                                        CanBeTriggeredByScrollBounceRight,
                                        CanBeTriggeredByScrollBounceBottom {}
}
