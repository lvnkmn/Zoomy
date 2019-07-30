public extension Logger {
    struct FormatSettings {

        public var shouldShowLevel: Bool

        public var shouldShowFile: Bool
        
        public var shouldShowFunction: Bool
        
        public var shouldShowLine: Bool
        
        public init(shouldShowLevel: Bool = false, shouldShowFile: Bool = false, shouldShowFunction: Bool = false, shouldShowLine: Bool = false) {
            self.shouldShowLevel = shouldShowLevel
            self.shouldShowFile = shouldShowFile
            self.shouldShowFunction = shouldShowFunction
            self.shouldShowLine = shouldShowLine
        }
    }
}

public extension Logger.FormatSettings {
    
    /// Will show everything up to line level
    static var lineSettings: Logger.FormatSettings {
        return Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: true)
    }
    
    /// Will show everything up to function level
    static var functionSettings: Logger.FormatSettings {
        return Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false)
    }
    
    /// Will show everything up to file level
    static var fileSettings: Logger.FormatSettings {
        return Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: false, shouldShowLine: false)
    }
    
    /// Will show everything up to logLevel level
    static var levelSettings: Logger.FormatSettings {
        return Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)
    }
    
    /// Will show nothing except message
    static var nothingSettings: Logger.FormatSettings {
        return Logger.FormatSettings(shouldShowLevel: false, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)
    }
}
