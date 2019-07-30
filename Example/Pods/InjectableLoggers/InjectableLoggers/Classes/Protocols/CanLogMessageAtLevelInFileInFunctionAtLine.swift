public protocol CanLogMessageAtLevelInFileInFunctionAtLine {

    func log(_ message: Any, atLevel level:Loglevel, inFile file: String?, inFunction function: String?, atLine line: Int?)
}

public extension CanLogMessageAtLevelInFileInFunctionAtLine {
    
    func logError(_ message: Any = "", inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        log(message, atLevel: .error, inFile: file, inFunction: function, atLine: line)
    }
    
    func logWarning(_ message: Any = "", inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        log(message, atLevel: .warning, inFile: file, inFunction: function, atLine: line)
    }
    
    func logInfo(_ message: Any = "", inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        log(message, atLevel: .info, inFile: file, inFunction: function, atLine: line)
    }
    
    func logVerbose(_ message: Any = "", inFile file: String? = #file, inFunction function: String? = #function, atLine line: Int? = #line) {
        log(message, atLevel: .verbose, inFile: file, inFunction: function, atLine: line)
    }
}
