extension CGRect {
    
    func transformedBy(_ transform: CGAffineTransform) -> CGRect {
        let view = UIView(frame: self)
        view.transform = transform
        return view.frame
    }
}
