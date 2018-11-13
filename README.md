<p align="center">
	<img src="https://raw.githubusercontent.com/parski/SnapshotTest/master/logo.png" width="540">
</p>

<p align="center">
	<a href="https://travis-ci.org/parski/SnapshotTest"><img src="https://img.shields.io/travis/rust-lang/rust/master.svg?style=flat-square" alt="master" /></a>
</p>

**SnapshotTest** is a simple view testing tool written completely in Swift to aid with development for Apple platforms. It's like unit testing for views.

### How
When **record mode** is active a snapshot assertion will record an image of the view and save it to a **specified directory**. This will cause the test to fail. When record mode is deactivated the snapshot assertion will record an image of the view and compare it to the saved reference image. Should they differ the test will fail.

### Setup
All SnapshotTest needs to know is where to save the reference images. This directory is specified using a test scheme environmental variable using the key: 

```
REFERENCE_IMAGE_DIR
```

Recommended reference image directory path is: 

```
$(SOURCE_ROOT)/$(PROJECT_NAME)Tests/ReferenceImages
```
It should look something like this:

![Test scheme arguments.](https://raw.githubusercontent.com/parski/SnapshotTest/master/reference_image_directory.png)

### Usage
If you are familiar with **XCTest** using **SnapshotTest** will be a breeze. Instead of subclassing **XCTestCase** you just need to subclass **SnapshotTestCase** and assert the view using `AssertSnapshot()` to test it.

```swift
class ViewTests: SnapshotTestCase {
    
    func testView_withAlteration() {
        // Given
        let view = View(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        
        // When
        view.alter()
        
        // Then
        AssertSnapshot(view)
    }
    
}
```
Currently **UIView**, **UIViewController** and **CALayer** are supported.

### Record mode
Record mode records a snapshot of your view within the current scope and stores it in the reference directory to compare with any subsequent assertions.
  
Note that record mode will fail the test and output the reference image path to the console.
  
```
🔴 RECORD MODE: Reference image saved to /Users/snap/App/AppTests/ReferenceImages/View/testView_withAlteration.png
```

#### Test case

To set the test case to record mode simply change the `recordMode` property to true.

```swift
class ViewTests: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
        recordMode = true
    }
    
}
```

The assertion will then record and save a reference image.

#### Global

To set record mode globally and record all snapshots for every assertion, set the class variable `recordMode` instead.

```swift
SnapshotTestCase.recordMode = true
```

Note that you will probably need to set up a [principal class](#principal-class) to guarantee that record mode is activated before your test suite is run.

#### Statement

To explicitly record a single snapshot you can instead use the `RecordSnapshot()` function:

```swift
class ViewTests: SnapshotTestCase {
    
    func testView_withAlteration() {
        // Given
        let view = View(frame: CGRect(x: 0, y: 0, width: 375, height: 100))
        
        // When
        view.alter()
        
        // Then
        RecordSnapshot(view)
    }
    
}
```

### Principal class

A principal class is automatically instantiated by `XCTest` when your test bundle is loaded. Think of it as a good place to put a global `setUp()` and `tearDown()`. A simple principal class might look like this:

```swift
import SnapshotTest

class TestObserver : NSObject {

    override init() {
        SnapshotTestCase.recordMode = true
    }
}

```

In your test bundle's `Info.plist`, add a key value pair:

```
<key>NSPrincipalClass</key>
<string>YourAppTests.TestObserver</string>
```

Where `YourAppTests` is the name of your test bundle.

This will activate record mode globally and is guaranteed to be run before your test suite.

### Options
SnapshotTest provides different ways to compare snapshots using several options.
  
| Option    | Description                                          |
|-----------|------------------------------------------------------|
| device    | Compares snapshots specific to a certain device.     |
| osVersion | Compares snapshots specific to a certain OS version. |

To use one or several options you just pass them to the options argument of the assertion:

```swift
AssertSnapshot(view, options: [.device, .osVersion])
```

### Platforms
The following platforms and minimum versions are supported:

* iOS 8.0
* tvOS 9.0

### Distribution
Use SnapshotTest by building it and integrating it into your project manually or by using a depencency manager. Currently only CocoaPods is supported with more to come.

#### CocoaPods
Just add the following line to your Podfile in the scope of your **test target**:

```ruby
target "MyAppTests" do
  use_frameworks!
  pod 'SnapshotTest' ~> 'X.Y.Z'
end
```
Replace `X.Y.Z` with the starting version you wish to use. Breaking backward compatability will be a last resort kind of deal but specifying version is still recommended.

### Contribute
SnapshotTest is licensed under the **BSD 2-clause License** and contributions are very welcome in the form of pull requests and issues.
