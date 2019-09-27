//
//  AsyncCollectionViewController.swift
//  Texture
//
//  Copyright (c) Facebook, Inc. and its affiliates.  All rights reserved.
//  Changes after 4/13/2017 are: Copyright (c) Pinterest, Inc.  All rights reserved.
//  Licensed under Apache 2.0: http://www.apache.org/licenses/LICENSE-2.0
//
// Sample was taken from [Texture Group github](https://github.com/TextureGroup/Texture/tree/master/examples/CustomCollectionView-Swift/Sample) and modified so that is has zoombehavior and imageges from this project

import UIKit
import AsyncDisplayKit
import Zoomy

class AsyncCollectionViewController: ASViewController<ASCollectionNode>, MosaicCollectionViewLayoutDelegate, ASCollectionDataSource, ASCollectionDelegate {
  
  var _sections = [[UIImage]]()
  let _collectionNode: ASCollectionNode
  let _layoutInspector = MosaicCollectionViewLayoutInspector()

  init() {
    let layout = MosaicCollectionViewLayout()
    layout.numberOfColumns = 3;
    layout.headerHeight = 44;
    _collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: layout)
    super.init(node: _collectionNode)
    layout.delegate = self

    _sections.append([]);
    var section = 0
    let numberOfimagesToDisplay = 100
    for idx in 0 ..< numberOfimagesToDisplay {
        _sections[section].append(Images.trees[idx % Images.trees.count])
      if ((idx + 1) % 5 == 0 && idx < numberOfimagesToDisplay - 1) {
        section += 1
        _sections.append([])
      }
    }
    
    _collectionNode.backgroundColor = UIColor.white
    _collectionNode.dataSource = self
    _collectionNode.delegate = self
    _collectionNode.layoutInspector = _layoutInspector
    _collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    _collectionNode.view.isScrollEnabled = true
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    let image = _sections[indexPath.section][indexPath.item]
    return {
        let node = ImageCellNode(with: image)
        
        DispatchQueue.main.async {
            self.addZoombehavior(for: node.imageNode, settings: .instaZoomSettings)
        }
        
        return node
    }
  }
  
  
  func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
    let textAttributes : NSDictionary = [
      convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline),
      convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor): UIColor.gray
    ]
    let textInsets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
    let textCellNode = ASTextCellNode(attributes: textAttributes as! [AnyHashable : Any], insets: textInsets)
    textCellNode.text = String(format: "Section %zd", indexPath.section + 1)
    return textCellNode
  }
  

  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return _sections.count
  }

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return _sections[section].count
  }

  internal func collectionView(_ collectionView: UICollectionView, layout: MosaicCollectionViewLayout, originalItemSizeAtIndexPath: IndexPath) -> CGSize {
    return _sections[originalItemSizeAtIndexPath.section][originalItemSizeAtIndexPath.item].size
  }
}

extension AsyncCollectionViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
        node.view.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
        node.view.isScrollEnabled = true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
