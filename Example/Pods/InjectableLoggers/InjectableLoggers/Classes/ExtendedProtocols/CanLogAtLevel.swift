public protocol CanLogAtLevel: CanLog, HasDefaultLoglevel {

    func log(atLevel level: Loglevel)
}

extension CanLogAtLevel {
    
    public func log() {
        log(atLevel: defaultLogLevel)
    }
    
    public func logError() {
        log(atLevel: .error)
    }
    
    public func logWarning() {
        log(atLevel: .warning)
    }
    
    public func logInfo() {
        log(atLevel: .info)
    }
    
    public func logVerbose() {
        log(atLevel: .verbose)
    }
}
