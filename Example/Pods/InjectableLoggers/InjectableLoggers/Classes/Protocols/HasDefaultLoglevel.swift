public protocol HasDefaultLoglevel {
    
    var defaultLogLevel: Loglevel { get }
}

public extension HasDefaultLoglevel {
    
    var defaultLogLevel: Loglevel {
        return .info
    }
}
