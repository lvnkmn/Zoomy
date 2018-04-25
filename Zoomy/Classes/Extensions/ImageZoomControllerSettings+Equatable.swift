import Foundation

extension ImageZoomControllerSettings: Equatable {
    
    public static func ==(lhs: ImageZoomControllerSettings, rhs: ImageZoomControllerSettings) -> Bool {
        return  lhs.zoomCancelingThreshold == rhs.zoomCancelingThreshold &&
                lhs.maximumZoomScale == rhs.maximumZoomScale &&
                lhs.isEnabled == rhs.isEnabled &&
                lhs.shouldDisplayBackground == rhs.shouldDisplayBackground &&
                lhs.primaryBackgroundColor == rhs.primaryBackgroundColor &&
                lhs.secundaryBackgroundColor == rhs.secundaryBackgroundColor &&
                lhs.neededTranslationToDismissOverlayOnScrollBounce == rhs.neededTranslationToDismissOverlayOnScrollBounce
    }
}
