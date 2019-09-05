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

class AsyncViewController: ASViewController<ASImageNode> {

    let imageNode = ASImageNode()
    
    init() {
        super.init(node: imageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageNode.image = Images.trees[4]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        #warning("Remove get rid of force unwrap before releasing")
        addZoombehavior(for: imageNode,
                        in: imageNode.view.superview!, //navigationController!.view,
                        settings: Settings.instaZoomSettings.configured{ $0.actionOnTapOverlay = Action.dismissOverlay }) //Non instazoom is still very glitchy
    }
}

#warning("TODO: Move this extension to Texture subspec before releasing")
extension ASImageNode: Zoomable {}
