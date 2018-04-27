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

open class SnapshotTestCase : XCTestCase {

    open var recordMode: Bool = false

    lazy var coordinator: SnapshotCoordinating = {
        return SnapshotCoordinator(className: String(describing: type(of: self)))
    }()

    public func AssertSnapshot(_ snapshotable: Snapshotable, options: Options = [], functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            if recordMode {
                try recordSnapshot(of: snapshotable, options: options, functionName: functionName, file: file, line: line)
            }
            else {
                try coordinator.compareSnapshot(of: snapshotable, options: options, functionName: functionName, line: line)
                XCTAssertTrue(true, file: file, line: line)
            }
        } catch SnapshotError.imageMismatch(let filename) {
            XCTFail("\(filename) is different from the reference image.", file: file, line: line)
        } catch {
            XCTFail("\(functionName) - \(error)", file: file, line: line)
        }

    }
    public func RecordSnapshot(_ snapshotable: Snapshotable, options: Options = [], functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            try recordSnapshot(of: snapshotable, options: options, functionName: functionName, file: file, line: line)
        } catch {
            XCTFail("\(functionName) - \(error)", file: file, line: line)
        }
        
    }
    
    private func recordSnapshot(of snapshotable: Snapshotable, options: Options, functionName: String, file: StaticString, line: UInt) throws {
        try coordinator.recordSnapshot(of: snapshotable, options: options, functionName: functionName, line: line)
        XCTFail("🔴 RECORD MODE: Reference image saved.", file: file, line: line)
    }

}
