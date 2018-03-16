//
//  SnapshotCoordinatorTests.swift
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

@testable import SnapshotTest
import XCTest

class SnapshotCoordinatorTests: XCTestCase {
    
    var sut: SnapshotCoordinator!
    var fileManagerMock: SnapshotFileManagerMock!
    var filenameFormatter: FilenameFormattingMock!
    
    override func setUp() {
        super.setUp()
        self.fileManagerMock = SnapshotFileManagerMock()
        self.filenameFormatter = FilenameFormattingMock()
        self.sut = SnapshotCoordinator(fileManager: self.fileManagerMock, filenameFormatter: filenameFormatter)
    }
    
    override func tearDown() {
        self.filenameFormatter = nil
        self.fileManagerMock = nil
        self.sut = nil
        super.tearDown()
    }
    
    // MARK: Compare Snapshot
    
    func testCompareSnapshot_withViewEqualToReferenceImage_shouldNotThrowError() {

        // Given
        let view = self.redSquareView()
        self.fileManagerMock.referenceImageReturnValue = UIImage(testFilename: "redSquare", ofType: "png")

        // When
        XCTAssertNoThrow(try self.sut.compareSnapshot(of: view, options: [], functionName: "redSquare", file: "", line: 0))
    }
    
    func testCompareSnapshot_withViewNotEqualToReferenceImage_shouldThrowError() {

        // Given
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .blue
        self.fileManagerMock.referenceImageReturnValue = UIImage(testFilename: "redSquare", ofType: "png")
        self.filenameFormatter.formatReturnValue = "File_redSquare"

        // When
        XCTAssertThrowsError(try self.sut.compareSnapshot(of: view, options: [], functionName: "redSquare", file: "File.swift", line: 0)) { error in
            XCTAssertEqual(error as? SnapshotError, SnapshotError.imageMismatch(filename: "File_redSquare"))
        }
    }

    // MARK: Record Snapshot

    func testRecordSnapshot_withRedView_shouldSaveReferenceImageOfViewWithCorrectFunctionName() throws {

        // Given
        let view = self.redSquareView()
        self.filenameFormatter.formatReturnValue = "File_redSquare"

        // When
        try self.sut.recordSnapshot(of: view, options: [], functionName: "redSquare", file: "", line: 0)

        // Then
        XCTAssertEqual(self.fileManagerMock.saveInvokeCount, 1)
        XCTAssertNotNil(self.fileManagerMock.saveReferenceImageArgument)
        XCTAssertEqual(self.fileManagerMock.saveFilenameArgument, "File_redSquare")
    }

    func testRecordSnapshot_withFileManagerError_shouldThrowSameError() {
        // Given
        let view = self.redSquareView()
        self.fileManagerMock.saveErrorToThrow = SnapshotFileManagerError.unableToSerializeReferenceImage

        // When
        XCTAssertThrowsError(try self.sut.recordSnapshot(of: view, options: [], functionName: "", file: "", line: 0)) { error in
            // Then
            XCTAssertEqual(error as? SnapshotFileManagerError, SnapshotFileManagerError.unableToSerializeReferenceImage)
        }
    }

    private func redSquareView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .red
        return view
    }
    
}

class FilenameFormattingMock : FilenameFormatting {

    var formatReturnValue: String = "filename"

    func format(sourceFile: StaticString, functionName: String, options: Options) -> String {
        return formatReturnValue
    }
}
