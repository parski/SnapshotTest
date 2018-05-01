//
//  CocoaPodsTests.swift
//  SnapshotTest
//
//  Copyright © 2017 SnapshotTest. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
//  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
//  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
//  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

@testable import CocoaPods
import SnapshotTest

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

        let label = UILabel()
        label.text = "Hello World"
        label.translatesAutoresizingMaskIntoConstraints = false

        let view = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 200))
        view.backgroundColor = .red
        view.addSubview(label)
        view.addConstraints([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        AssertSnapshot(view)
    }

    func testLayerSnapshot() {
        let layer = CAShapeLayer()
        layer.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        layer.lineWidth = 20
        layer.fillColor = UIColor.blue.cgColor
        layer.borderColor = UIColor.green.cgColor
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 20).cgPath

        AssertSnapshot(layer)
    }

    func testViewControllerSnapshot() {

        let label = UILabel()
        label.text = "Hello World"
        label.translatesAutoresizingMaskIntoConstraints = false

        let viewController = UIViewController()
        viewController.view.backgroundColor = .lightGray
        viewController.view.addSubview(label)
        viewController.view.addConstraints([
            label.centerXAnchor.constraint(equalTo: viewController.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: viewController.view.centerYAnchor)
        ])

        let navigationController = UINavigationController(rootViewController: viewController)

        AssertSnapshot(navigationController)
    }
    
    func testViewWithStretchedImageViewSnapshot() {
        // Given
        let stretchedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        stretchedImageView.image = #imageLiteral(resourceName: "goose")
        
        // Then
        AssertSnapshot(stretchedImageView)
    }
    
}
