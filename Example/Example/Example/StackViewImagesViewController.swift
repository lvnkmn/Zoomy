import UIKit
import Zoomy

class StackViewImagesViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeStoryBoardImageView()
        
        Images.trees.forEach { (image) in
            let imageView = UIImageView(image: image)
            imageView.addImageAspectRatioContraint()
            self.stackView.addArrangedSubview(imageView)
            
            addZoombehavior(for: imageView,
                            settings: Settings().configured {   $0.shouldDisplayBackground = true
                                                                $0.primaryBackgroundColor = UIColor.black.withAlphaComponent(0.8)
                                                                $0.secundaryBackgroundColor = .black
                                                                $0.actionOnScrollBounceBottom = Action.dismissOverlay
                                                                $0.actionOnTapOverlay = Action.dismissOverlay })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        imageZoomControllers.values.forEach{ $0.dismissOverlay() }
    }

    func removeStoryBoardImageView() {
        stackView.removeArrangedSubview(stackView.arrangedSubviews[0])
    }
}

//MARK: - ZoomDelegate
extension StackViewImagesViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
//        print("did begin presenting overlay for imageView: \(imageView)")
        scrollView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
//        print("did end presenting overlay for imageView: \(imageView)")
        scrollView.isScrollEnabled = true
    }
    
    func contentStateDidChange(from fromState: ImageZoomControllerContentState, to toState: ImageZoomControllerContentState) {
//        print("contentState did change from state: \(fromState) to state: \(toState)")
        //You might want to show/hide statusbar here
    }
}
