import UIKit
import Zoomy

class FloatingActionButtonViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.alpha = 0
        
        addZoombehavior(for: imageView, below: dismissButton)
    }
    
    @IBAction func didPressDismissButton(_ sender: UIButton) {
        imageZoomControllers[imageView]?.dismissOverlay()
    }
}

extension FloatingActionButtonViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
        UIView.animate(withDuration: 1) {
            self.dismissButton.alpha = 1
        }
    }
    
    func willDismissOverlay() {
        UIView.animate(withDuration: 0.5) {
            self.dismissButton.alpha = 0
        }
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
        UIView.animate(withDuration: 0.5) {
            self.dismissButton.alpha = 0
        }
    }
}
