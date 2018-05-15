import InjectableLoggers


private let settings = Logger.Settings(activeLogLevel: Loglevel.warning,
                                       defaultLogLevel: Loglevel.info,
                                       formatSettings: [.verbose : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                        .info : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: true, shouldShowFunction: true, shouldShowLine: false),
                                                        .warning : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false),
                                                        .error : Logger.FormatSettings(shouldShowLevel: true, shouldShowFile: false, shouldShowFunction: false, shouldShowLine: false)])

internal let logger = ZoomyLogger(settings: settings)

internal typealias Loglevel = InjectableLoggers.Loglevel
