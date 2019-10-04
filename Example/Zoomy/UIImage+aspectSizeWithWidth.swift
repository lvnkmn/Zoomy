//
//  UIImage+aspectSizeWithWidth.swift
//  Zoomy_Example
//
//  Created by menno on 11/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {
    
    func aspectSize(withWidth width: CGFloat) -> CGSize {
        let sizeRatio = size.height / size.width
        return .init(width: width,
                     height: width * sizeRatio)
    }
}
