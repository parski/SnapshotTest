<p align="center">
	<img src="logo.png" width="540">
</p>

<p align="center">
	<a href="https://travis-ci.org/parski/SnapshotTest"><img src="https://img.shields.io/travis/rust-lang/rust/master.svg?style=flat-square" alt="master" /></a>
</p>

**SnapshotTest** is a simple view testing tool written in pure Swift to aid with development for Apple platforms. It's like unit testing for views.

### Usage
If you are familiar with **XCTest** using **SnapshotTest** will be a breeze:

```swift
class ViewTests: SnapshotTestCase {
    
    func testView_withAlteration() {
        // Given
        let view = View()
        
        // When
        view.alter()
        
        // Then
        AssertSnapshot(view)
    }
    
}
```

### Platforms
The following platforms and minimum versions are supported:

* iOS 8.0
* tvOS 8.0

### Contribute
SnapshotTest is licensed under the **BSD 2-clause License** and contributions are very welcome in the form of pull requests and issues.