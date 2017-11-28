//
//  SnapshotTestCase.swift
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

import UIKit
import XCTest

public enum SnapshotError : Error {
    case unableToTakeSnapshot
    case snapshotNotMatchingReference(snapshot: UIImage, reference: UIImage)
}

open class SnapshotTestCase : XCTestCase {

    var fileManager: SnapshotFileManaging = SnapshotFileManager()
    var options: DeviceOptions = []

    open var recordMode: Bool = false
    
    public func AssertSnapshot(_ view: UIView, functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            if recordMode {
                try self.recordSnapshot(of: view, functionName: functionName)
                XCTAssert(false, "🔴 RECORD MODE: Reference image saved.", file: file, line: line)
            }
            else {
               try self.compareSnapshot(ofView: view, functionName: functionName, file: file, line: line)
            }
        }
        catch SnapshotError.unableToTakeSnapshot {
            XCTAssert(false, "\(file):\(line):\(functionName) - Unable to take snapshot of \(view)", file: file, line: line);
        }
        catch SnapshotError.snapshotNotMatchingReference(snapshot: let snapshotImage, reference: let referenceImage) {
            let snapshotAttachment = XCTAttachment(image: snapshotImage)
            snapshotAttachment.name = "View snapshot image"
            add(snapshotAttachment)

            let referenceAttachment = XCTAttachment(image: referenceImage)
            referenceAttachment.name = "Reference image"
            add(referenceAttachment)
            XCTAssert(false, "\(functionName) is different from the reference image.", file: file, line: line);
        }
        catch {
            XCTAssert(false, "\(file):\(line):\(functionName) - failed with error: \(error)", file: file, line: line)
        }
    }
    
    func compareSnapshot(ofView view: UIView, functionName: String = #function, file: StaticString = #file, line: UInt = #line) throws {
        guard let snapshotImage = self.image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }
        let referenceImage = try self.fileManager.referenceImage(forFunctionName: functionName, options: self.options )

        if snapshotImage.normalizedData() != referenceImage.normalizedData() {
            throw SnapshotError.snapshotNotMatchingReference(snapshot: snapshotImage, reference: referenceImage)
        }
    }
    
    func recordSnapshot(of view: UIView, functionName: String) throws {
        guard let referenceImage = self.image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }
        try self.fileManager.save(referenceImage: referenceImage, functionName: functionName, options: self.options)
    }
    
    private func image(forView view: UIView) -> UIImage? {

        UIGraphicsBeginImageContext(view.bounds.size)
        view.layoutIfNeeded()
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
