//
//  DeviceOptionTests.swift
//  SnapshotTest-iOS Tests
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

@testable import SnapshotTest
import XCTest

class DeviceOptionTests: XCTestCase {
    
    func testDeviceOptions_withType_shouldContainType() {
        // Given
        let sut: DeviceOptions = [.type]
        
        // Then
        XCTAssertTrue(sut.contains(.type))
    }
    
    func testDeviceOptions_withType_shouldNotContainOSVersion() {
        // Given
        let sut: DeviceOptions = [.type]
        
        // Then
        XCTAssertFalse(sut.contains(.osVersion))
    }
    
    func testDeviceOptions_withTypeAndOSVersion_shouldContainBoth() {
        // Given
        let sut: DeviceOptions = [.type, .osVersion]
        
        // Then
        XCTAssertTrue(sut.contains(.type))
        XCTAssertTrue(sut.contains(.osVersion))
    }
    
}
