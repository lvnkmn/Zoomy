public protocol CanLog {
    
    func log()
}

public extension CanLog {
    
    public func log() {
        print("")
    }
}
