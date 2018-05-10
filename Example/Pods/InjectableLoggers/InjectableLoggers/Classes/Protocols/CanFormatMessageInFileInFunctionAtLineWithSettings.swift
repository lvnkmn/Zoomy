public protocol CanFormatMessageInFileInFunctionAtLineWithSettings {
    
    func format(_ message: Any, with levelString: String, in file: String?, in function: String?, at line: Int?, with settings: Logger.FormatSettings) -> String
}
