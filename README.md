# SWModalController

## Requirements

- iOS 11.0+
- Xcode 11.0+
- Swift 5.3+

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

To add SWModalController to your Xcode project, select `File > Add Packages` and enter repository URL:

```
https://github.com/0x3337/SWModalController
```

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate SWModalController into your project manually.

## Usage

### Quick Start

```swift
import SWModalController

class ViewController: SWModalController {
  // ...
}
```

### Custom Height

Property `preferredContentSize.height` sets custom height for controller. Default is `0.0`:

```swift
preferredContentSize.height = 512
```

### Interactive transition with UIScrollView

To make the transition interactive with `UIScrollView` you need to override `modalView` and set the bounces as `false`:

```swift
lazy var scrollView: UIScrollView = {
  let scrollView = UIScrollView()
  scrollView.bounces = false

  return scrollView
}()

override var modalView: UIView {
  return scrollView
}
```

## License
SWModalController is released under the MIT license. See LICENSE for details.
