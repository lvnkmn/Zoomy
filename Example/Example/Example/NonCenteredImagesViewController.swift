import UIKit
import Zoomy

class NonCenteredImagesViewController: UIViewController {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = Settings.defaultSettings .with(actionOnTapOverlay: Action.dismissOverlay)
                                                .with(actionOnDoubleTapImageView: Action.zoomToFit)
        
        addZoombehavior(for: imageView1, settings: settings)
        addZoombehavior(for: imageView2, settings: settings)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageZoomControllers.values.forEach{ $0.dismissOverlay() }
    }
}

//MARK: - ZoomDelegate
extension NonCenteredImagesViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
//        print("did begin presenting overlay for imageView: \(imageView)")
        imageZoomControllers.values.filter{ $0.imageView !== imageView }.forEach{ $0.dismissOverlay() }
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
//        print("did end presenting overlay for imageView: \(imageView)")
    }
    
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {
//        print("contentState did change from state: \(fromState) to state: \(toState)")
        //You might want to show/hide statusbar here
    }
}
