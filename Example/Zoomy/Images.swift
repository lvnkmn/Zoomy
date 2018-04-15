//
//  Images.swift
//  Zoomy_Example
//
//  Created by Menno on 15/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

struct Images {
    
    static let trees: [UIImage] = numbers(0, upTo: 8).map{"Trees_\($0)"}.compactMap{UIImage(named: $0)}
}

extension Images {
    static func numbers(_ lowerNumber: Int, upTo upperNumber: Int) -> [String] {
        var numbers = [String]()
        
        for currentNumber in lowerNumber...upperNumber {
            numbers.append(String(currentNumber))
        }
        
        return numbers
    }
}
