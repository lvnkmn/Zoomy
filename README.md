# Zoomy
 [![Version](http://img.shields.io/cocoapods/v/Zoomy.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![Platform](http://img.shields.io/cocoapods/p/Zoomy.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![License](http://img.shields.io/cocoapods/l/Zoomy.svg?style=flat)](LICENSE)

Zoomy allows you to add seamless scrollView like zooming to UIImageView's in any view hierarchy.

## Example

![](Art/Gif/1.gif)![](Art/Gif/2.gif)![](Art/Gif/3.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Setup
Just import `Zoomy`, and add zoomBehavior for the imageViews that need it
```swift
import Zoomy
```
```swift
//Somewhere in your viewController:
addZoombehavior(for: imageView)
```
For more advanced use cases:
```shell
pod try 'Zoomy'
```

## Installation

Zoomy is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Zoomy'
```

## Author

Menno Lovink, mclovink@me.com

## License

Zoomy is available under the MIT license. See the LICENSE file for more info.
