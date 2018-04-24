import Foundation

public struct ImageZoomControllerSettings {
    
    public init() {}
    
    /// When scale of imageView is below this threshold when initial pinch gesture ends, the overlay will be dismissed
    public var zoomCancelingThreshold: ImageViewScale = 1.5
    
    /// The miximum zoomsScale at which an image will be displayed
    public var maximumZoomScale: ImageScale = 2
    
    /// Causes the behavior of the ImageZoomController to (temporarily) be disabled when needed
    public var isEnabled = true
    
    /// Whether or not a background view needs to be displayed behind the zoomed imageViews
    public var shouldDisplayBackground = false
    
    /// BackgroundView's color will animate to this value when content becomes smaller than the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var primaryBackgroundColor = UIColor.white.withAlphaComponent(0.8)
    
    /// BackgroundView's color will animate to this value when content becomes bigger than or equal to any dimension of the view it's displayed in
    /// This will only have effect when shouldDisplayBackground is set to true
    public var secundaryBackgroundColor = UIColor.white
    
    
    /// The amount of point that have to be panned while scrollView is bouncing in order to dismiss the overlay
    /// Note: Settings this value alone doesn't have effect when dismissal by bounce is not enabled
    public var neededTranslationToDismissOverlayOnScrollBounce: CGFloat = 80
}
