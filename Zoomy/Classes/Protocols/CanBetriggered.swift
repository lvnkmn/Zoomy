public protocol CanBeTriggeredByAnyInteraction: CanBeTriggeredByOverlayTap,
                                                CanBeTriggeredByScrollBounceTop,
                                                CanBeTriggeredByScrollBounceLeft,
                                                CanBeTriggeredByScrollBounceRight,
                                                CanBeTriggeredByScrollBounceBottom {}

public protocol CanBeTriggeredByOverlayTap{}
public protocol CanBeTriggeredByScrollBounceTop{}
public protocol CanBeTriggeredByScrollBounceLeft{}
public protocol CanBeTriggeredByScrollBounceRight{}
public protocol CanBeTriggeredByScrollBounceBottom{}
