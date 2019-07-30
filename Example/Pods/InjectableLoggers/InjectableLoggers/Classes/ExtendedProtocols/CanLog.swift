public protocol CanLog {
    
    func log()
}

public extension CanLog {
    
    func log() {
        print("")
    }
}
