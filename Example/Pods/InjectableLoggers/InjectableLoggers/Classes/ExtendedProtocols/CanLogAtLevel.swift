public protocol CanLogAtLevel: CanLog, HasDefaultLoglevel {

    func log(atLevel level: Loglevel)
}

extension CanLogAtLevel {
    
    public func log() {
        log(atLevel: defaultLogLevel)
    }
}
