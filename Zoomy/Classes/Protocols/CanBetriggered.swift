public protocol CanBeTriggeredByAnyInteraction: CanBeTriggeredByImageViewTap,
                                                CanBeTriggeredByImageViewDoubleTap,
                                                CanBeTriggeredByOverlayTap,
                                                CanBeTriggeredByOverlayDoubleTap,
                                                CanBeTriggeredByBackgroundViewTap,
                                                CanBeTriggeredByBackgroundDoubleTap,
                                                CanBeTriggeredByScrollBounceTop,
                                                CanBeTriggeredByScrollBounceLeft,
                                                CanBeTriggeredByScrollBounceRight,
                                                CanBeTriggeredByScrollBounceBottom {}

public protocol CanBeTriggered {}
public protocol CanBeTriggeredByImageViewTap: CanBeTriggered {}
public protocol CanBeTriggeredByImageViewDoubleTap: CanBeTriggered {}
public protocol CanBeTriggeredByOverlayTap: CanBeTriggered {}
public protocol CanBeTriggeredByOverlayDoubleTap: CanBeTriggered {}
public protocol CanBeTriggeredByBackgroundViewTap: CanBeTriggered {}
public protocol CanBeTriggeredByBackgroundDoubleTap: CanBeTriggered {}
public protocol CanBeTriggeredByScrollBounceTop: CanBeTriggered {}
public protocol CanBeTriggeredByScrollBounceLeft: CanBeTriggered {}
public protocol CanBeTriggeredByScrollBounceRight: CanBeTriggered {}
public protocol CanBeTriggeredByScrollBounceBottom: CanBeTriggered {}
