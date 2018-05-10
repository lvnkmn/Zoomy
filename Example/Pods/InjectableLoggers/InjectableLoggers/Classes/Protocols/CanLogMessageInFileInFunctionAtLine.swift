public protocol CanLogMessageInFileInFunctionAtLine {

    func log(_ message: Any, inFile file: String?, inFunction function: String?, atLine line: Int?)
}
