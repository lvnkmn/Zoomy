import UIKit

extension UIImage {
    
    func aspectSize(withWidth width: CGFloat) -> CGSize {
        let sizeRatio = size.height / size.width
        return .init(width: width,
                     height: width * sizeRatio)
    }
}
