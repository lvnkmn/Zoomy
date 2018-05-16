internal extension CGAffineTransform {
    
    static func transform(withScale scale: CGFloat, translation: CGPoint = CGPoint.zero, center: CGPoint) -> CGAffineTransform {
        return CGAffineTransform.identity   .translatedBy(x: translation.x,
                                                          y: translation.y)
                                            .translatedBy(x: center.x * (1-scale),
                                                          y: center.y * (1-scale))
                                            .scaledBy(x: scale, y: scale)
    }
    
    static func transform(withScale scale: CGFloat, translation: CGPoint = CGPoint.zero) -> CGAffineTransform {
        return CGAffineTransform.identity   .translatedBy(x: translation.x,
                                                          y: translation.y)
                                            .scaledBy(x: scale,
                                                      y: scale)
    }
}
