//
//  CocoaPodsTests.swift
//  CocoaPodsTests
//
//  Created by Andre Stenvall on 2017-11-28.
//  Copyright © 2017 SnapshotTest. All rights reserved.
//

import XCTest
@testable import SnapshotTest
@testable import CocoaPods

class CocoaPodsTests: SnapshotTestCase {
    
    override func setUp() {
        super.setUp()
//        self.recordMode = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewSnapshot() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        view.backgroundColor = .red

        AssertSnapshot(view)
    }
}
