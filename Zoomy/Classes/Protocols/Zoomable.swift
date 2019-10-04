public protocol Zoomable: class {
    
    var image: UIImage? { get }
    var view: UIView { get }
    var contentMode: UIView.ContentMode { get }
}
