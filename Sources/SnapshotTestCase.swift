//
//  SnapshotTestCase.swift
//  SnapshotTestCase
//
//  Created by Pär Strindevall
//  Copyright © 2017 Plata o Plomo
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
    case snapshotDifferentFromReferenceImage
}

public class SnapshotTestCase : XCTestCase {
    var recordMode: Bool = false
    var fileManager: SnapshotFileManaging = SnapshotFileManager()
    var isDeviceAgnostic: Bool = false
    
    func Verify(view: UIView, functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            guard self.recordMode == false else {
                try self.recordSnapshot(of: view, functionName: functionName)
                XCTAssert(false, "🔴 RECORD MODE: Reference image saved.")
                return
            }
            let isEqualToSnapshot = try self.compareSnapshot(ofView: view, functionName: functionName, file: file, line: line)
            guard isEqualToSnapshot else { XCTAssert(false, "\(functionName) is different from the reference image."); return }
            XCTAssertTrue(true)
        } catch { XCTAssert(false, "\(functionName) - \(file):\(line) failed with error: \(error)") }
    }
    
    func compareSnapshot(ofView view: UIView, functionName: String = #function, file: StaticString = #file, line: UInt = #line) throws -> Bool {
        guard let snapshot = self.image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }
        let referenceImage = try self.fileManager.referenceImage(forFunctionName: functionName, isDeviceAgnostic: self.isDeviceAgnostic)

        return snapshot.normalizedData() == referenceImage.normalizedData()
    }
    
    func recordSnapshot(of view: UIView, functionName: String) throws {
        guard let referenceImage = self.image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }
        try self.fileManager.save(referenceImage: referenceImage, functionName: functionName, isDeviceAgnostic: self.isDeviceAgnostic)
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
