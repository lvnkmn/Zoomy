import Foundation
import PureLayout
import InjectableLoggers

internal class ZoomyLogger: Logger {
    
    internal func logGesture(with gestureRecognizer: UIGestureRecognizer, atLevel level: Loglevel? = nil, inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        guard gestureRecognizer.state != .changed else { return }
        
        log(gestureRecognizer.state, atLevel: level, inFile: file, inFunction: function, atLine: line)
    }
}
