public protocol CanBeTriggeredByAnyInteraction: CanBeTriggeredByImageViewTap,
                                                CanBeTriggeredByImageViewDoubleTap,
                                                CanBeTriggeredByOverlayTap,
                                                CanBeTriggeredByScrollBounceTop,
                                                CanBeTriggeredByScrollBounceLeft,
                                                CanBeTriggeredByScrollBounceRight,
                                                CanBeTriggeredByScrollBounceBottom {}

public protocol CanBeTriggeredByImageViewTap {}
public protocol CanBeTriggeredByImageViewDoubleTap {}
public protocol CanBeTriggeredByOverlayTap {}
public protocol CanBeTriggeredByScrollBounceTop {}
public protocol CanBeTriggeredByScrollBounceLeft {}
public protocol CanBeTriggeredByScrollBounceRight {}
public protocol CanBeTriggeredByScrollBounceBottom {}
