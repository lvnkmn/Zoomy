//
//  MockLogger.swift
//  Zoomy_Example
//
//  Created by Menno on 30/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public class MockLogger {
    
    public typealias LoggedMessage = (level: Loglevel?, message: Any, file: String?, function: String?, line: Int?)
    
    public var defaultLogLevel: Loglevel = .info
    
    public private(set) var loggedMessages = [LoggedMessage]()
    
    public init() {}
}

//MARK: - Public Methods

public extension MockLogger {
    
    func loggedMessages(atLevel logLevel: Loglevel) -> [LoggedMessage] {
        return loggedMessages.filter{ $0.level == logLevel }
    }
}

//MARK: CanLogMessageAtLevel
extension MockLogger: CanLogMessageAtLevel {

    public func log(_ message: Any, atLevel level: Loglevel) {
        log(message, atLevel: level, inFile: nil, inFunction: nil, atLine: nil)
    }
}

//MARK: CanCanLogMessageAtLevelInFileInFunctionAtLine
extension MockLogger: CanLogMessageAtLevelInFileInFunctionAtLine {
    
    public func log(_ message: Any, atLevel level: Loglevel, inFile file: String?, inFunction function: String?, atLine line: Int?) {
        loggedMessages.append((level: level, message: message, file: file, function: function, line: line))
    }
}
