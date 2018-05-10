public protocol CanLogMessageAtLevelInFileInFunctionAtLine {

    func log(_ message: Any, atLevel level:Loglevel, inFile file: String?, inFunction function: String?, atLine line: Int?)
}
