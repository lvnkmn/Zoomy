import UIKit
import Zoomy

class InstaZoomViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let parentView = parent?.view else { return }
        
        addZoombehavior(for: imageView, in:parentView, settings: Settings.instaZoomSettings)
    }
}
