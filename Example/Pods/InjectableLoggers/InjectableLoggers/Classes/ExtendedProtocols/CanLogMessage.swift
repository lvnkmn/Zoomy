public protocol CanLogMessage: CanLog {
    
    func log(_ message: Any)
}

extension CanLogMessage {
    
    public func log() {
        log("")
    }
}
