import UIKit
import AsyncDisplayKit
import Zoomy

class SingleImageTextureViewController: ASDKViewController<ASDisplayNode> {

    let backgroundNode = ASDisplayNode()
    let imageNode = ASImageNode()
    
    override init() {
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
                        settings: Settings().configured{ $0.actionOnTapOverlay = Action.dismissOverlay })
    }
}

private extension SingleImageTextureViewController {
    
    func configureImageNode() {
        let image = Images.trees[4]
        imageNode.image = image
        imageNode.frame = .init(origin: .init(x: 0, y: 300),
                                size: image.aspectSize(withWidth: view.frame.width))
    }
}