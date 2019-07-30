//
//  UIView.Contentmode+CustomStringConvertible.swift
//  Zoomy_Example
//
//  Created by menno on 30/07/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

extension UIView.ContentMode: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .bottom:
            return "bottom"
        case .bottomLeft:
            return "bottomLeft"
        case .bottomRight:
            return "bottomRight"
        case .center:
            return "center"
        case .left:
            return "left"
        case .redraw:
            return "redraw"
        case .right:
            return "right"
        case .scaleAspectFill:
            return "scaleAspectFill"
        case .scaleAspectFit:
            return "scaleAspectFit"
        case .scaleToFill:
            return "scaleToFill"
        case .top:
            return "top"
        case .topLeft:
            return "topLeft"
        case .topRight:
            return "ropRight"
        }
    }
}
