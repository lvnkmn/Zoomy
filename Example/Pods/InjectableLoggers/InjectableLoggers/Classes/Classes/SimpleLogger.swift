open class SimpleLogger {
    
    public let settings: Settings
    
    /// All calls to `log(message:at level:)` will be relayed to this instance
    /// Inject a mock here if needed
    public var relay: CanLogMessageAtLevel?
    
    public init(settings: Settings = .verboseSettings) {
        self.settings = settings
    }
}

//MARK: Open Methods
extension SimpleLogger {
    
    open func format(_ message: Any, with logLevelString: String) -> String {
        
        var formattedMessage = logLevelString
        
        if (message as? String)?.count != 0 {
            if formattedMessage.count > 0 {
                formattedMessage.append(" ")
            }
            
            formattedMessage.append("\(message)")
        }
        
        return formattedMessage
    }
    
    open func shouldLog(at level: Loglevel) -> Bool {
        guard level != .inactive else { return false }
        return level.rawValue >= settings.activeLogLevel.rawValue
    }
}

//MARK: CanLogMessageAtLevel
extension SimpleLogger: CanLogMessageAtLevel {

    open func log(_ message: Any, atLevel level: Loglevel) {
        relay?.log(message, atLevel: level)
        guard shouldLog(at: level) else { return }
        settings.destination.log(format(message, with: settings.loglevelStrings[level] ?? ""))
    }
}

// MARK: HasDefaultLoglevel
extension SimpleLogger: HasDefaultLoglevel {
    
    open var defaultLogLevel: Loglevel {
        return settings.defaultLogLevel
    }
}
