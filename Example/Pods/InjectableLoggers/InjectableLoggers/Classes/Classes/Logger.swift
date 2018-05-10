open class Logger {
    
    /// All calls to `log(message: atLevel: inFile: inFunction: atLine: line)` will be relayed to this instance
    /// Inject a mock here if needed
    public var relay: CanLogMessageAtLevelInFileInFunctionAtLine?
    public let settings: Settings
    
    public init(settings: Settings = .verboseSettings) {
        self.settings = settings
    }
}

//MARK: CanCanLogMessageAtLevelInFileInFunctionAtLine
extension Logger: CanLogMessageAtLevelInFileInFunctionAtLine {
    
    open func log(_ message: Any = "", atLevel level: Loglevel, inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        relay?.log(message, atLevel: level, inFile: file, inFunction: function, atLine: line)
        guard shouldLog(at: level) else { return }
        settings.destination.log(settings.formatter.format(message,
                                                           with: settings.loglevelStrings[level] ?? "",
                                                           in: file,
                                                           in: function,
                                                           at: line,
                                                           with: settings.formatSettings[level] ?? .nothingSettings))
    }
}

//MARK: CanLogMessageInFileInFunctionAtLine
extension Logger: CanLogMessageInFileInFunctionAtLine {
    
    open func log(_ message: Any = "", inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        log(message, atLevel: defaultLogLevel, inFile: file, inFunction: function, atLine: line)
    }
}

//MARK: HasDefaultLoglevel
extension Logger: HasDefaultLoglevel {
    
    open var defaultLogLevel: Loglevel {
        return settings.defaultLogLevel
    }
}

extension Logger {

    open func shouldLog(at level: Loglevel) -> Bool {
        guard level != .inactive else { return false }
        return level.rawValue >= settings.activeLogLevel.rawValue
    }
}


