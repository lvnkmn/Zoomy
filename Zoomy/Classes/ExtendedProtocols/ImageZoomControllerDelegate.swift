//  Created by Menno on 09/04/2018.
//

import Foundation

public protocol ImageZoomControllerDelegate: class {

    func didBeginPresentingOverlay(for imageView: UIImageView)
    func didEndPresentingOverlay(for imageView: UIImageView)
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState)
}

public extension ImageZoomControllerDelegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {}
    func didEndPresentingOverlay(for imageView: UIImageView) {}
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {}
}
