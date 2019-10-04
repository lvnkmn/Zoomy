//
//  ExamplesViewController.swift
//  Zoomy_Example
//
//  Created by Menno on 13/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ExamplesViewController: UITableViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? UITableViewCell else { return }
        segue.destination.title = cell.textLabel?.text
    }
}

extension ExamplesViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController(belongingTo: indexPath) else { return }
        
        viewController.title = tableView.cellForRow(at: indexPath)?.textLabel?.text
        navigationController?.pushViewController(viewController, animated: true)
        
    }
}

private extension ExamplesViewController {
    
    func viewController(belongingTo indexPath: IndexPath) -> UIViewController? {
        
        switch indexPath {
        case .singleImageTextureExample:
            return SingleImageTextureViewController()
        case .imageCollectionTextureExample:
            return ImageCollectionTextureViewController()
        default:
            return nil
        }
    }
}

private extension IndexPath {
    
    static let singleImageTextureExample = IndexPath(item: 0, section: 1)
    static let imageCollectionTextureExample = IndexPath(item: 1, section: 1)
}
