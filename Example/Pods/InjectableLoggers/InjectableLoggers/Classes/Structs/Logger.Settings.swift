extension Logger {
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
        
        /// Will turn logLevel, message, file, function and line into the strings that will be logged to destination
        public var formatter: CanFormatMessageInFileInFunctionAtLineWithSettings

        /// Format settings per logLevel that will used by formatter to format messages
        public var formatSettings: [Loglevel: FormatSettings]
        
        public init(activeLogLevel: Loglevel = .verbose,
                    defaultLogLevel: Loglevel = .info,
                    loglevelStrings: [Loglevel: String] = [.verbose: "🔍", .info: "ℹ️", .warning: "⚠️", .error:"⛔️"],
                    destination: CanLogMessage = ConsoleLogger(),
                    formatter:  CanFormatMessageInFileInFunctionAtLineWithSettings = Formatter(),
                    formatSettings: [Loglevel: FormatSettings] = [.verbose : FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true),
                                                                  .info : FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                                  .warning : FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                                  .error : FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false)]) {
            self.activeLogLevel = activeLogLevel
            self.defaultLogLevel = defaultLogLevel
            self.loglevelStrings = loglevelStrings
            self.destination = destination
            self.formatter = formatter
            self.formatSettings = formatSettings
        }
    }
}

public extension Logger.Settings {
    
    /// Will cause messages for all levels to be logged to the destination
    static var verboseSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .verbose
        return settings
    }
    
    /// Will cause messages for Loglevel.info and higher to be logged to the destination
    static var infoSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .info
        return settings
    }
    
    /// Will cause messages for Loglevel.warning and higher to be logged to the destination
    static var warningSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .warning
        return settings
    }
    
    /// Will cause messages for Loglevel.error and higher to be logged to the destination
    static var errorSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .error
        return settings
    }
    
    /// Will cause no message to be logged to the destination
    static var inactiveSettings: Logger.Settings {
        var settings = Logger.Settings()
        settings.activeLogLevel = .inactive
        return settings
    }
    
    /// Same settings but with provided defaultLogLevel
    func with(defaultLogLevel: Loglevel) -> Logger.Settings {
        var settings = self
        settings.defaultLogLevel = defaultLogLevel
        return settings
    }
    
    /// Same settings but with provided destination
    func with(destination: CanLogMessage) -> Logger.Settings {
        var settings = self
        settings.destination = destination
        return settings
    }
    
    /// Same settings but with provided formatsettings
    func with(formatSettings: [Loglevel: Logger.FormatSettings]) -> Logger.Settings {
        var settings = self
        settings.formatSettings = formatSettings
        return settings
    }
}
