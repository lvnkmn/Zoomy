
internal protocol ImageZoomControllerShorthand: PublicImageZoomControllerShorthand, InternalImageZoomControllerShorthand {}

internal protocol InternalImageZoomControllerShorthand {}
internal extension InternalImageZoomControllerShorthand {
    
    typealias State = ImageZoomControllerState
    
    typealias IsNotPresentingOverlayState = ImageZoomControllerIsNotPresentingOverlayState
    typealias IsPresentingScrollViewOverlayState = ImageZoomControllerIsPresentingScrollViewOverlayState
    typealias IsPresentingImageViewOverlayState = ImageZoomControllerIsPresentingImageViewOverlayState
    typealias IsHandlingScrollViewBounceTriggeredDismissalState = ImageZoomControllerIsHandlingScrollViewBounceTriggeredDismissalState
}

public protocol PublicImageZoomControllerShorthand {}
public extension PublicImageZoomControllerShorthand {
    
    typealias Delegate = ImageZoomControllerDelegate
    typealias Settings = ImageZoomControllerSettings
    typealias ContentState = ImageZoomControllerContentState
    typealias Action = ImageZoomControllerAction
    typealias DismissOverlayAction = ImageZoomControllerDismissOverlayAction
    typealias NoneAction = ImageZoomControllerNoneAction
}
