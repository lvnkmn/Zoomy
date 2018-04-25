public class ImageZoomControllerAction {
    
    public static var dismissOverlay: ImageZoomControllerDismissOverlayAction {
        return ImageZoomControllerDismissOverlayAction()
    }
    
    public  static var none: ImageZoomControllerNoneAction {
        return ImageZoomControllerNoneAction()
    }
}

public class ImageZoomControllerNoneAction: ImageZoomControllerAction,
                                            CanBeTriggeredByAnyInteraction{}

public class ImageZoomControllerDismissOverlayAction:   ImageZoomControllerAction,
                                                        CanBeTriggeredByOverlayTap,
                                                        CanBeTriggeredByScrollBounceTop,
                                                        CanBeTriggeredByScrollBounceLeft,
                                                        CanBeTriggeredByScrollBounceRight,
                                                        CanBeTriggeredByScrollBounceBottom{}
