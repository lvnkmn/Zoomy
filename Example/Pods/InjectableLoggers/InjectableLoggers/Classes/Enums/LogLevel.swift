public enum Loglevel: UInt {
    case verbose = 0
    case info = 1
    case warning = 2
    case error = 3
    case inactive = 4
}

public extension Loglevel {
    public static var all: [Loglevel] {
        return [.verbose, .info, .warning, .error, .inactive]
    }
}
