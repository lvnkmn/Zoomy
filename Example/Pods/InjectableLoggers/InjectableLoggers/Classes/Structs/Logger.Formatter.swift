import Foundation

public extension Logger {
    
    struct Formatter {
        
        public init(){}
    }
}

extension Logger.Formatter: CanFormatMessageInFileInFunctionAtLineWithSettings {
    
    public func format(_ message: Any, with levelString: String, in file: String?, in function: String?, at line: Int?, with settings: Logger.FormatSettings) -> String {
        var formattedMessage = ""
        
        if settings.shouldShowLevel {
            formattedMessage.append(levelString)
        }
        
        if  settings.shouldShowFile,
            let file = file {
            if formattedMessage.count > 0 {
                formattedMessage.append(" ")
            }
            formattedMessage.append("\(format(fileName: file))")
            
            if  settings.shouldShowFunction,
                let function = function {
                formattedMessage.append(".\(function)")
            }
        } else if   settings.shouldShowFunction,
                    let function = function {
            if formattedMessage.count > 0 {
                formattedMessage.append(" ")
            }
            
            formattedMessage.append(function)
        }
        
        if  settings.shouldShowLine,
            let line = line {
            if formattedMessage.count > 0 {
                formattedMessage.append(" ")
            }
            
            formattedMessage.append("\(line)" )
        }
        
        if (message as? String)?.count != 0 {
            if formattedMessage.count > 0 {
                formattedMessage.append(" ")
            }
            
            formattedMessage.append("\(message)")
        }
        
        return formattedMessage
    }
}

private extension Logger.Formatter {
    
    func format(fileName: String) -> String {
        return String(URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent)
    }
}
