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

    /**
     Flag for activating record mode in the current test case.
     - Note: Tests will always fail in record mode.
     */
    open var recordMode: Bool = false
    
    /**
     Flag for activating record mode for all test cases.
     - Note: Tests will always fail in record mode.
     */
    public static var recordMode: Bool = false

    lazy var coordinator: SnapshotCoordinating = {
        return SnapshotCoordinator(className: String(describing: type(of: self)))
    }()

    /**
     Compares a snapshotable to a previously saved reference image.
     - Parameter snapshotable: View construct conforming to the `Snapshotable` protocol.
     - Parameter options: A set of parameters for more specific comparisons. See `Option` for available options.
     - Parameter functionName: Inferred test function name.
     - Parameter file: Inferred name of test file.
     - Parameter line: Inferred line of test function declaration.
     - Important: If record mode (see `recordMode`) is active this function records and saves a snapshot instead.
     */
    public func AssertSnapshot(_ snapshotable: Snapshotable, options: Options = [], functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            if SnapshotTestCase.recordMode || recordMode {
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
    
    /**
    Records a snapshot of a snapshotable and saves a reference image to disk.
    - Parameter snapshotable: View construct conforming to the `Snapshotable` protocol.
    - Parameter options: A set of parameters for more specific comparisons. See `Option` for available options.
    - Parameter functionName: Inferred test function name.
    - Parameter file: Inferred name of test file.
    - Parameter line: Inferred line of test function declaration.
    - Important: Reference images will be saved to the directory specified using the `REFERENCE_IMAGE_DIR` environmental variable.
    - Note: Tests will always fail when recording.
    */
    public func RecordSnapshot(_ snapshotable: Snapshotable, options: Options = [], functionName: String = #function, file: StaticString = #file, line: UInt = #line) {
        do {
            try recordSnapshot(of: snapshotable, options: options, functionName: functionName, file: file, line: line)
        } catch {
            XCTFail("\(functionName) - \(error)", file: file, line: line)
        }
        
    }
    
    private func recordSnapshot(of snapshotable: Snapshotable, options: Options, functionName: String, file: StaticString, line: UInt) throws {
        let referenceImageLocation = try coordinator.recordSnapshot(of: snapshotable, options: options, functionName: functionName, line: line)
        XCTFail("🔴 RECORD MODE: Reference image saved to \(referenceImageLocation.path)", file: file, line: line)
    }

}
