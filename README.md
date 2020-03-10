# HeaderFooterRefreshView

[![CI Status](https://img.shields.io/travis/Meggapixxel/HeaderFooterRefreshView.svg?style=flat)](https://travis-ci.org/Meggapixxel/HeaderFooterRefreshView)
[![Version](https://img.shields.io/cocoapods/v/HeaderFooterRefreshView.svg?style=flat)](https://cocoapods.org/pods/HeaderFooterRefreshView)
[![License](https://img.shields.io/cocoapods/l/HeaderFooterRefreshView.svg?style=flat)](https://cocoapods.org/pods/HeaderFooterRefreshView)
[![Platform](https://img.shields.io/cocoapods/p/HeaderFooterRefreshView.svg?style=flat)](https://cocoapods.org/pods/HeaderFooterRefreshView)

## Requirements

- iOS 10.0+
- Swift 5.0+

## Installation

HeaderFooterRefreshView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HeaderFooterRefreshView'
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Header (Manual)
```swift
let headerView = scrollView.header.setManualControl() // Default is 44
headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
```

Header (Auto)
```swift
let headerView = scrollView.header.setAutoControl(height: 60)
headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
```

Footer (Manual)
```swift
let footerView = scrollView.footer.setManualControl() // Default is 44
headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
```

Footer (Auto)
```swift
let footerView = scrollView.footer.setAutoControl(height: 60)
headerView.addTarget(self, action: #selector(headerRefresh), for: .valueChanged)
```

## Author

Meggapixxel, zhydenkodeveloper@gmail.com

## License

HeaderFooterRefreshView is available under the MIT license. See the LICENSE file for more info.
