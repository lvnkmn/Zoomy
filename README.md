![](Art/Banner.png)

Zoomy allows you to add seamless scrollView and instagram like zooming to UIImageViews in any view hierarchy.

## Example

![](Art/Gif/1.gif)![](Art/Gif/2.gif)![](Art/Gif/3.gif)

Example project can be found in the Example folder

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

There's a lot more [triggers](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Structs/ImageZoomControllerSettings.swift#L44-L72) and [actions](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Classes/ImageZoomControllerActions.swift#L8-L26) to choose from.

### Zooming a collectionviewcell

```swift
public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    //After your regular dequeue and configuration:
    addZoombehavior(for: cell.imageView)
        
    return cell
}
```

### Other examples

* [Zooming non centered images](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/NonCenteredImagesViewController.swift)
* [Zooming scrollable images](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/StackViewImagesViewController.swift)
* [Zooming underneath floating action button](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/FloatingActionButtonViewController.swift)
* [Dynamically changing gesture actions](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Example/Zoomy/ChangingActionsViewController.swift)

### A note about zooming images that live inside scrollviews

Zooming inside any viewhierarchy will work perfectly fine using Zoomy, however sometimes you want to disable existing behaviors while zooming. A good example of this is when zooming images that are subviews of a scrollview.

For best performance just implement these Zoomy.Delegate methods:

```swift
extension YourViewController: Zoomy.Delegate {
    
    func didBeginPresentingOverlay(for imageView: Zoomable) {
        scrollView.isScrollEnabled = false
    }
    
    func didEndPresentingOverlay(for imageView: Zoomable) {
        scrollView.isScrollEnabled = true
    }
}
```

No need to set the viewController as a delegate to anyting. This is infered using conditional conformance. In case you're interested in seeing how this is done, see [this](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/Extensions/UIViewController%2BCanManageZoomBehavior.swift#L3) and [this](https://github.com/lvnkmn/Zoomy/blob/3c6e6195190515522dd84d2653f61acdfaeef897/Zoomy/Classes/ExtendedProtocols/CanManageZoomBehaviors.swift#L72).

## Texture

All the code examples provided above work with texture's `ImageNode` as well. All that is needed for this is adding `extension ASImageNode: Zoomable {}` anywhere in your targets sources. See the example projects for basic and more advanced usage of texture.

## There's more to come

See the [roadmap](https://github.com/lvnkmn/Zoomy/labels/roadmap) for upcoming features.

Missing anyting or something is not working as desired? [Create an issue](https://github.com/lvnkmn/Zoomy/issues/new) and it will likely be picked up. 

## Support

There may not always be time for personal support on how to implement Zoomy in different scenario's. Hopefully the code is clear enough to get done what's needed 💪. In case you've implemented a scenario thats not described in this readme or the examples, feel free to [create a pull request](https://github.com/lvnkmn/Zoomy/compare?expand=1), that would be pretty cool actually.  

## Installation

Zoomy is available through [Swift Package Manager](https://swift.org/package-manager/). To install it, simply add it to your project using this repository's URL as explained [here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

## Credits & Acknowledgements

Cover photo by [Leonardo Yip](https://unsplash.com/@yipleonardo), all other images that have been used can be found on [Unsplash](https://unsplash.com).

## License

Zoomy is available under the MIT license. See the LICENSE file for more info.
