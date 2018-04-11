# Zoomy

Zoomy allows you to add seamless scrollView like zooming to UIImageView's in any view hierarchy.

## Example

![](Art/Gif/Example.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Setup
Just import `Zoomy`, and store an instance of `ImageZoomController` for the imageView you'd like to be able to zoom
```swift
import Zoomy
```
```swift
let zoomcontroller: ImageZoomController?
```
```swift
zoomcontroller = ImageZoomController(view: view, imageView: imageView)
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
