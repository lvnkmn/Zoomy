public protocol CanLogMessageAtLevel: CanLogMessage, CanLogAtLevel {
    
    func log(_ message: Any, atLevel level: Loglevel)
}

public extension CanLogMessageAtLevel {
    
    func log() {
        log("", atLevel: defaultLogLevel)
    }
    
    func log(_ message: Any) {
        log(message, atLevel: defaultLogLevel)
    }
    
    func log(atLevel level: Loglevel) {
        log("", atLevel: level)
    }
}
