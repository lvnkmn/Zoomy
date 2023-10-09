import UIKit

extension UIImageView {
    
    func addImageAspectRatioContraint() {
        guard let image = image else { return }
        
        addConstraint(NSLayoutConstraint(item: self,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .width,
                                         multiplier: image.size.height / image.size.width,
                                         constant: 0))
    }
}
