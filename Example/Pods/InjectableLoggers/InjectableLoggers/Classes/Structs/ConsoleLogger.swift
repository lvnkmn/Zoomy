/// Can Log messages to the console
public struct ConsoleLogger {
    
    public init() {}
}

//MARK: CanLogMessage
extension ConsoleLogger: CanLogMessage {
    
    public func log(_ message: Any) {
        print(message)
    }
}
