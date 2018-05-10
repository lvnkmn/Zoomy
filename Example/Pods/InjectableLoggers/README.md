# InjectableLoggers
 [![Version](http://img.shields.io/cocoapods/v/InjectableLoggers.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![Platform](http://img.shields.io/cocoapods/p/InjectableLoggers.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![License](http://img.shields.io/cocoapods/l/InjectableLoggers.svg?style=flat)](LICENSE)

A nice set of protocols that will help logger(s) at being loosely coupled, injectable and testable.

## Example

To see the example project, run the following in your terminal:

`pod try InjectableLoggers`

## Setup
Just add: 

`import InjectableLoggers`

to the files where you need some injectable logging action.

### Making your logger injectable

Depending on how much functionality you want (to expose) from a logger, make a logger conform to one of the following protocols:

`CanLog`

`CanLogMessage`

`CanLogMessageAtLevel`

All of thes protocols have lightweight and sensible default implementations and make sure you never have to implement more than one of their methods.

### Making an existing logger injectable

#### When it uses instance methods for logging

```swift
extension SomeoneElsesLogger: CanLogMessageAtLevel /* CanLog || CanLogMessage */ {

	func log(_ message Any, at: LogLevel) {
		//call existing logging functionality here
	}
}
```

#### When it uses class methods for logging

```swift
struct Logger: CanLogMessageAtLevel /* CanLog || CanLogMessage */ {

	func log(_ message Any, at: LogLevel) {
		//call existing logging functionality here
	}
}
```

### Doing some logging

Depending on which protocols your loggers conform to, you can call the following methods:

```swift
logger.log() //Will log "" to default LogLevel if expected
logger.log(42) //Will log 42 to default LogLevel if expected
logger.log("Something not to important", at LogLevel.verbose)
logger.log("Something broke!", at: LogLevel.error)
```

Bonus! This lib comes with two concrete loggers 🎉

**ConsoleLogger**

```swift
let logger: CanLogMessage = ConsoleLogger()

logger.log() // logs to console: ""
logger.log(42) // logs to console: 42
logger.log("Hi there") // logs to console: "Hi there"
```

**Logger**

```swift
let logger: CanLogMessageAtLevel = Logger(settings: .warningSettings)

logger.log("Some info", atLevel LogLevel.info) //Won't log anything because of settings
logger.log("Something's up") // logs to settings.destination: "⚠️ Something's up"
logger.log("Something went wrong") // logs to settings.destination: "⛔️ Something's up"
```

`settings.destination`?

Yes, settings has it's own `CanLogMessage` instance (`ConsoleLogger` by default) which is used for logging all created strings. This not only made `Logger` completely testable (and tested) but it also allows you to log to different destinations if needed.


### Testing that what was expected is being logged
Another bonus! This lib comes with a pretty handy mock logger called `MockLogger` 🎉

```swift
class ViewControllerTests: XCTestCase {
    
    var sut: ViewController!
    var mockLogger: MockLogger!
    
    override func setUp() {
        super.setUp()
        
        sut = ViewController()
        mockLogger = MockLogger()
    }
    
    // MARK: Single line assertions
    func testViewDidLoad() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.viewDidLoad()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages(at: Loglevel.info).last?.message as? String, "viewDidLoad()")
    }
    
    // MARK: More verbose assertions
    func testDidReceiveMemoryWarning() {
        //Arrange
        sut.logger = mockLogger //Inject mockLogger
        
        //Act
        sut.didReceiveMemoryWarning()
        
        //Assert
        XCTAssertEqual(mockLogger.loggedMessages.last?.message as? String, "didReceiveMemoryWarning()")
        XCTAssertEqual(mockLogger.loggedMessages.last?.level, Loglevel.warning)
    }
}
```

For some more advance testing check out the example project.

## Installation

InjectableLoggers is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'InjectableLoggers'
```

## Author

Menno Lovink, mclovink@me.com

## License

InjectableLoggers is available under the MIT license. See the LICENSE file for more info.
