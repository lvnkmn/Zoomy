public extension SimpleLogger {
    
    public struct Settings {
        
        /// All messages with loglevel equal to or above this logLevel will be logged
        public var activeLogLevel: Loglevel
        
        /// Messages logged without a logLevel will automatically be logged at this logLevel
        public var defaultLogLevel: Loglevel
        
        /// The strings that will be used to identify each loglevel in a formatted message
        public var loglevelStrings: [Loglevel: String]
        
        /// All messages created by formatter will be logged to this destination
        /// By default this destination will be a ConsoleLogger but any other destination can be injected either here on in the constructor
        public var destination: CanLogMessage
        
        public init(activeLogLevel: Loglevel = .verbose,
                    defaultLogLevel: Loglevel = .info,
                    loglevelStrings: [Loglevel: String] = [.verbose: "🔍", .info: "ℹ️", .warning: "⚠️", .error:"⛔️"],
                    destination: CanLogMessage = ConsoleLogger()) {
            self.activeLogLevel = activeLogLevel
            self.defaultLogLevel = defaultLogLevel
            self.loglevelStrings = loglevelStrings
            self.destination = destination
        }
    }
}

public extension SimpleLogger.Settings {
    
    /// Will cause messages for all levels to be logged to the destination
    static var verboseSettings: SimpleLogger.Settings {
        var settings = SimpleLogger.Settings()
        settings.activeLogLevel = .verbose
        return settings
    }
    
    /// Will cause messages for Loglevel.info and higher to be logged to the destination
    static var infoSettings: SimpleLogger.Settings {
        var settings = SimpleLogger.Settings()
        settings.activeLogLevel = .info
        return settings
    }
    
    /// Will cause messages for Loglevel.warning and higher to be logged to the destination
    static var warningSettings: SimpleLogger.Settings {
        var settings = SimpleLogger.Settings()
        settings.activeLogLevel = .warning
        return settings
    }
    
    /// Will cause messages for Loglevel.error and higher to be logged to the destination
    static var errorSettings: SimpleLogger.Settings {
        var settings = SimpleLogger.Settings()
        settings.activeLogLevel = .error
        return settings
    }
    
    /// Will cause no message to be logged to the destination
    static var inactiveSettings: SimpleLogger.Settings {
        var settings = SimpleLogger.Settings()
        settings.activeLogLevel = .inactive
        return settings
    }
    
    /// Same settings but with provided defaultLogLevel
    func with(defaultLogLevel: Loglevel) -> SimpleLogger.Settings {
        var settings = self
        settings.defaultLogLevel = defaultLogLevel
        return settings
    }
    
    /// Same settings but with provided destination
    func with(destination: CanLogMessage) -> SimpleLogger.Settings {
        var settings = self
        settings.destination = destination
        return settings
    }
}
