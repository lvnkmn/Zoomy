import UIKit

extension ImageZoomController {

    internal class Factory {
        typealias Context = ImageZoomController
    }
}

//MARK: GestureRecognizers
extension ImageZoomController.Factory {
    
    func makeTapGestureRecognizer(for context: Context) -> UITapGestureRecognizer {
        logger.log(atLevel: .verbose)
        let gestureRecognizer = UITapGestureRecognizer(target: context, action: #selector(context.didTap(with:)))
        gestureRecognizer.delegate = context
        return gestureRecognizer
    }
    
    func makeDoubleTapGestureRecognizer(for context: Context) -> UITapGestureRecognizer {
        logger.log(atLevel: .verbose)
        let gestureRecognizer = makeTapGestureRecognizer(for: context)
        gestureRecognizer.numberOfTapsRequired = 2
        return gestureRecognizer
    }
    
    func makePinchGestureRecognizer(for context: Context) -> UIPinchGestureRecognizer {
        logger.log(atLevel: .verbose)
        let gestureRecognizer = UIPinchGestureRecognizer(target: context, action: #selector(context.didPinch(with:)))
        gestureRecognizer.delegate = context
        return gestureRecognizer
    }
    
    func makePanGestureRecognizer(for context: Context) -> UIPanGestureRecognizer {
        logger.log(atLevel: .verbose)
        let gestureRecognizer = UIPanGestureRecognizer(target: context, action: #selector(context.didPan(with:)))
        gestureRecognizer.delegate = context
        return gestureRecognizer
    }
}

//MARK: Views

extension ImageZoomController.Factory {
    
    func makeScrollView(for context: Context) -> UIScrollView {
        logger.log(atLevel: .verbose)
        let view = UIScrollView()
        view.clipsToBounds = false
        view.delegate = context
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = true
        view.alwaysBounceVertical = true
        view.alwaysBounceHorizontal = true
        return view
    }
    
    func makeBackgroundView(for context: Context) -> UIView {
        logger.log(atLevel: .verbose)
        let view = UIView()
        view.backgroundColor = context.settings.primaryBackgroundColor
        view.addGestureRecognizer(context.backgroundViewTapGestureRecognizer)
        view.addGestureRecognizer(context.backgroundViewDoubleTapGestureRecognizer)
        return view
    }
    
    func makeScrollableImageView(for context: Context) -> UIImageView {
        logger.log(atLevel: .verbose)
        let view = UIImageView()
        view.addGestureRecognizer(context.scrollableImageViewTapGestureRecognizer)
        view.addGestureRecognizer(context.scrollableImageViewDoubleTapGestureRecognizer)
        view.addGestureRecognizer(context.scrollableImageViewPanGestureRecognizer)
        view.isUserInteractionEnabled = true
        view.image = context.image
        return view
    }
    
    func makeOverlayImageView(for context: Context) -> UIImageView {
        logger.log(atLevel: .verbose)
        let view = UIImageView()
        view.image = context.image
        return view
    }
}
