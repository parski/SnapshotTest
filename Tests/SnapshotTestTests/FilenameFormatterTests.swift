//
//  FilenameFormatterTests.swift
//  SnapshotTest
//
//  Copyright © 2018 SnapshotTest. All rights reserved.
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

@testable import SnapshotTest
import Foundation
import XCTest

class FilenameFormatterTests: XCTestCase {

    var sut: FilenameFormatter!
    var deviceMock: UIDevice!

    override func setUp() {
        super.setUp()
        deviceMock = UIDeviceMock(model: "Apple TV", systemVersion: "11.2.3")
        sut = FilenameFormatter(device: deviceMock)
    }

    override func tearDown() {
        sut = nil
        deviceMock = nil
        super.tearDown()
    }

    func testFormat_withoutOptions_shouldReturnCorrectlyFormattedFilname() {
        // When
        let filename = sut.format(sourceFile: "Source/File.swift", functionName: "functionName()", options: [])

        // Then
        XCTAssertEqual(filename, "File_functionName")
    }

    func testFormat_withOptionDevice_shouldReturnCorrectlyFormattedFilname() {
        // When
        let filename = sut.format(sourceFile: "Source/File.swift", functionName: "functionName()", options: [.device])

        // Then
        XCTAssertEqual(filename, "File_functionName_AppleTV")
    }

    func testFormat_withOptionOSVersion_shouldReturnCorrectlyFormattedFilname() {
        // When
        let filename = sut.format(sourceFile: "Source/File.swift", functionName: "functionName()", options: [.osVersion])

        // Then
        XCTAssertEqual(filename, "File_functionName_11_2_3")
    }

    func testFormat_withOptionDeviceAndOSVersion_shouldReturnCorrectlyFormattedFilname() {
        // When
        let filename = sut.format(sourceFile: "Source/File.swift", functionName: "functionName()", options: [.device, .osVersion])

        // Then
        XCTAssertEqual(filename, "File_functionName_AppleTV_11_2_3")
    }

    func testFormat_withOptionDeviceAndOSVersionInAnotherOrdering_shouldReturnCorrectlyFormattedFilname() {
        // When
        let filename = sut.format(sourceFile: "Source/File.swift", functionName: "functionName()", options: [.osVersion, .device])

        // Then
        XCTAssertEqual(filename, "File_functionName_AppleTV_11_2_3")
    }
}
