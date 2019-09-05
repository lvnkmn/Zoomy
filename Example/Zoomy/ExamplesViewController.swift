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
        if indexPath == .asyncViewController {
            return AsyncViewController()
        } else {
            return nil
        }
    }
}

private extension IndexPath {
    
    static let asyncViewController = IndexPath(item: 7, section: 0)
}
