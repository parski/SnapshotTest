//
//  SnapshotTestCaseTests.swift
//  SnapshotTestCaseTests
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

@testable import SnapshotTest
import XCTest

class SnapshotTestCaseTests: XCTestCase {
    
    var sut: SnapshotTestCase!
    
    var fileManagerMock: SnapshotFileManagerMock!
    
    override func setUp() {
        super.setUp()
        self.sut = SnapshotTestCase()
        self.fileManagerMock = SnapshotFileManagerMock()
        self.sut.fileManager = self.fileManagerMock
    }
    
    override func tearDown() {
        self.fileManagerMock = nil
        self.sut = nil
        super.tearDown()
    }
    
    // MARK: Compare Snapshot
    
    func testCompareSnapshot_withViewEqualToReferenceImage_shouldReturnTrue() {
        // Given
        let view = self.redSquareView()
        self.fileManagerMock.referenceImageReturnValue = UIImage(testFilename: "redSquare", ofType: "png", scale: 2.0)

        // When
        let result = try! self.sut.compareSnapshot(ofView: view)

        // Then
        XCTAssertTrue(result)
    }
    
    func testCompareSnapshot_withViewNotEqualToReferenceImage_shouldReturnFalse() {
        // Given
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .blue
        self.fileManagerMock.referenceImageReturnValue = UIImage(testFilename: "redSquare", ofType: "png")

        // When
        let result = try! self.sut.compareSnapshot(ofView: view)

        // Then
        XCTAssertFalse(result)
    }

    // MARK: Record Snapshot

    func testRecordSnapshot_withRedView_shouldSaveReferenceImageOfViewWithCorrectFunctionName() {
        // Given
        let view = self.redSquareView()
        let functionName = "testView"

        // When
        try? self.sut.recordSnapshot(of: view, functionName: functionName)

        // Then
        XCTAssertEqual(self.fileManagerMock.saveInvokeCount, 1)
        XCTAssertNotNil(self.fileManagerMock.saveReferenceImageArgument)
        XCTAssertEqual(self.fileManagerMock.saveFunctionNameArgument, functionName)
    }

    func testRecordSnapshot_withFileManagerError_shouldThrowSameError() {
        // Given
        let view = self.redSquareView()
        let errorToThrow = SnapshotFileManagerError.unableToSerializeReferenceImage
        self.fileManagerMock.saveErrorToThrow = errorToThrow

        // When
        do { try self.sut.recordSnapshot(of: view, functionName: "testError") }

        // Then
        catch { XCTAssertTrue(error as! SnapshotFileManagerError == errorToThrow) }
    }

    private func redSquareView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        return view
    }
    
}
