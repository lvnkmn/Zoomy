public protocol CanAnimate {
    func animate(_ animations:@escaping ()->(), completion:(()->())?)
}

public extension CanAnimate {
    
    func animate(_ animations:@escaping ()->()) {
        animate(animations, completion: nil)
    }
}
