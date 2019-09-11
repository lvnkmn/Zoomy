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

        imageNode.image = Images.trees[4]
        imageNode.frame = .init(x: 20, y: 100, width: view.frame.size.width - 40, height: 500)
        backgroundNode.addSubnode(imageNode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addZoombehavior(for: imageNode,
                        settings: Settings.instaZoomSettings.configured{ $0.actionOnTapOverlay = Action.dismissOverlay }) //Non instazoom is still very glitchy
    }
}

#warning("TODO: Move this extension to Texture subspec before releasing")
extension ASImageNode: Zoomable {}
