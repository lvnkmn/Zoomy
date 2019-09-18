import UIKit
import InjectableLoggers

extension UIView {
    
    func pinEdgesToSuperviewEdges() {
        guard let superview = superview else { return logger.logError("expected superview") }

        translatesAutoresizingMaskIntoConstraints = false
        
        let edges: [NSLayoutConstraint.Attribute] = [.top, .right, .bottom, .left]
        
        for edge in edges {
            NSLayoutConstraint(item: self,
                               attribute: edge,
                               relatedBy: .equal,
                               toItem: superview,
                               attribute: edge,
                               multiplier: 1,
                               constant: 0).isActive = true
        }
    }
}
