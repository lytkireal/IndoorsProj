# IndoorsSDK
> Short blurb about what your product does.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

One to two paragraph statement about your product and what it does.

![](header.png)

## Requirements

- iOS 8.0+ - ???
- Xcode 7.3 - ???

## Installation

#### Manually
1. Download and drop ```IndoorsSDK.framework``` in your project (with checked checkbox  ```Copy if needed```).
2. In your project select ```TARGETS/YourProject/General/Embedded Binaries``` and drag&drop ```IndoorsSDK.framework```.
3. Create in ```YourProject``` new file with extension ```Header File``` and set name to this file like a ```YourProject-Bridging-Header.h```.
4. In this ```YourProject-Bridging-Header.h``` write
``` swift
#import "IndoorsSDK.h"
```
5. Select  ```YourProject/IndoorsSDK.framework/Headers/IndoorsSDK.h``` and then  ```Show in Finder```. After you found file  ```IndoorsSDK.h``` drag&drop into your project nearby ```YourProject-Bridging-Header.h``` file (with unchecked checkbox  ```Copy if needed```, checked checkbox  ```Create groups```)
6. In ```TARGETS/YourProject/Build Settings/Swift Compiler - General/Objective-C Bridging Header``` drag&drop ```YourProject-Bridging-Header.h```.
7. Enjoy!



## Meta

Indoors Navigation Team – team@indoorsnavi.pro

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
