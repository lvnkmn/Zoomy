import Foundation

extension ImageZoomControllerSettings: Equatable {
    
    public static func ==(lhs: ImageZoomControllerSettings, rhs: ImageZoomControllerSettings) -> Bool {
        return  lhs.zoomCancelingThreshold == rhs.zoomCancelingThreshold &&
                lhs.minimumZoomScale == rhs.minimumZoomScale &&
                lhs.maximumZoomScale == rhs.maximumZoomScale &&
                lhs.isEnabled == rhs.isEnabled &&
                lhs.shouldDisplayBackground == rhs.shouldDisplayBackground &&
                lhs.primaryBackgroundColor == rhs.primaryBackgroundColor &&
                lhs.secondaryBackgroundColor == rhs.secondaryBackgroundColor &&
                lhs.neededTranslationToDismissOverlayOnScrollBounce == rhs.neededTranslationToDismissOverlayOnScrollBounce
    }
}
