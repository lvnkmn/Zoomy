# Zoomy
 [![Version](http://img.shields.io/cocoapods/v/Zoomy.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![Platform](http://img.shields.io/cocoapods/p/Zoomy.svg?style=flat)](http://cocoapods.org/pods/Zoomy) [![License](http://img.shields.io/cocoapods/l/Zoomy.svg?style=flat)](LICENSE)

Zoomy allows you to add seamless scrollView and instagram like zooming to UIImageView's in any view hierarchy.

## Example

![](Art/Gif/1.gif)![](Art/Gif/2.gif)![](Art/Gif/3.gif)

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Setup
Just add

```swift
import Zoomy
```
to the files that of the code that needs zoombehavior.

## Usage
All of the folowing snippets are expected to be called from within to your viewcontroller. 

Somewhere after `viewDidLoad` should work just fine.

### Scrollable zooming

```swift
addZoombehavior(for: imageView)
```

### Insta zooming

```swift
addZoombehavior(for: imageView, settings: .instaZoomSettings)
```

### Zooming above navigationbar/tabbar

```swift
guard let parentView = parent?.view else { return }
addZoombehavior(for: imageView, in:parentView)
```

### Zooming below UI element

```swift
addZoombehavior(for: imageView, below: dismissButton)
```

### Zooming with some custom gesture actions

```swift
let settings = Settings.defaultSettings
    .with(actionOnTapOverlay: Action.dismissOverlay)
    .with(actionOnDoubleTapImageView: Action.zoomIn)
        
addZoombehavior(for: imageView, settings: settings)
```

There's a lot more [triggers](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Structs/ImageZoomControllerSettings.swift#L44-L72) and [actions](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Classes/ImageZoomControllerActions.swift#L8-L26) to choose from.

### Zooming a collectionviewcell

```swift
public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    //After your regular dequeue and configuration:
    addZoombehavior(for: cell.imageView)
        
    return cell
}
```

### Other examples

`pod try 'Zoomy'` to load the example project.

Or check some of the sample code directly:

* [Zooming non centered images](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/NonCenteredImagesViewController.swift)
* [Zooming scrollable images](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/StackViewImagesViewController.swift)
* [Zooming underneath floating action button](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/FloatingActionButtonViewController.swift)
* [Dynamically changing gesture actions](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/ChangingActionsViewController.swift)

### A note about zooming images that live inside scrollviews

Zooming inside any viewhierarchy will work perfectly fine using Zoomy, however sometimes you want to disable existing behaviors while zooming. A good example of this is when zooming images that are subviews of a scrollview.

For best performance just implement these Zoomy.Delegate methods:

```swift
extension YourViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: UIImageView) {
        scrollView.isScrollEnabled = true
    }
}
```

No need to set the viewController as a delegate to anyting. This is infered using conditional conformance. In case you're interested in seeing how this is done, see [this](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Extensions/UIViewController%2BCanManageZoomBehavior.swift#L3) and [this](https://github.com/mennolovink/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/ExtendedProtocols/CanManageZoomBehaviors.swift#L72).

## There's more to come

See the [roadmap](https://github.com/mennolovink/Zoomy/labels/roadmap) for upcoming features.

Missing anyting or something is not working as desired? [Create an issue](https://github.com/mennolovink/Zoomy/issues/new) and it will likely be picked up.

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
