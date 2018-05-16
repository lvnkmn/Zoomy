internal protocol CanPerformAction {
    
    func perform(action: ImageZoomControllerAction, triggeredBy gestureRecognizer: UIGestureRecognizer?)
}
