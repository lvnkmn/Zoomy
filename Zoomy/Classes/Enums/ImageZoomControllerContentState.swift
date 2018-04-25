import Foundation

/// Shows to what extend the displayed content fits in the view it's displayed in
public enum ImageZoomControllerContentState {
    /// When displayed content width and height are smaller than the view it's displayed in
    case smallerThanAnsestorView
    
    /// When displayed content either fits or has bigger width or height or height than the view it's displayed in
    case fillsAnsestorView
}
