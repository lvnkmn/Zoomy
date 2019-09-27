//
//  AsyncViewController.swift
//  Zoomy_Example
//
//  Created by menno on 05/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Zoomy

class AsyncViewController: ASViewController<ASDisplayNode> {

    let backgroundNode = ASDisplayNode()
    let imageNode = ASImageNode()
    
    init() {
        super.init(node: backgroundNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureImageNode()
    
        backgroundNode.addSubnode(imageNode)
        
        addZoombehavior(for: imageNode,
                        settings: Settings.instaZoomSettings.configured{ $0.actionOnTapOverlay = Action.dismissOverlay })
    }
}

private extension AsyncViewController {
    
    func configureImageNode() {
        let image = Images.trees[4]
        imageNode.image = image
        imageNode.frame = .init(origin: .init(x: 0, y: 300),
                                size: image.aspectSize(withWidth: view.frame.width))
    }
}
