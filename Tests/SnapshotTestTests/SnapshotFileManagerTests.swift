//
//  SnapshotFileManagerTests.swift
//  SnapshotTestCaseTests
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

class SnapshotFileManagerTests: XCTestCase {
    
    var sut: SnapshotFileManager!
    
    var fileManagerMock: FileManagerMock!
    var dataHandlerMock: DataHandlerMock!
    var deviceInformationProviderMock: DeviceInformationProviderMock!
    
    override func setUp() {
        super.setUp()
        self.sut = SnapshotFileManager()
        self.fileManagerMock = FileManagerMock()
        self.sut.fileManager = fileManagerMock
        self.dataHandlerMock = DataHandlerMock()
        self.sut.dataHandler = self.dataHandlerMock
        self.deviceInformationProviderMock = DeviceInformationProviderMock()
        self.sut.deviceInformationProvider = self.deviceInformationProviderMock
    }
    
    override func tearDown() {
        self.sut = nil
        self.fileManagerMock = nil
        self.dataHandlerMock = nil
        super.tearDown()
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveFileManagerBeDefaultFileManager() {
        // Given
        self.sut = SnapshotFileManager()
        
        // Then
        XCTAssert(self.sut.fileManager === FileManager.default)
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveDataWriterBeInstanceOfDataWriter() {
        // Given
        self.sut = SnapshotFileManager()
        
        // Then
        XCTAssertTrue(self.sut.dataHandler as? DataHandler != nil)
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveEnvironmentalVariableProviderBeInstanceOfEnvironmentalVariableProvider() {
        // Given
        self.sut = SnapshotFileManager()
        
        // Then
        XCTAssertTrue(self.sut.environmentalVariableProvider as? EnvironmentalVariableProvider != nil)
    }
    
    // MARK: Environmental Variable Provider
    
    func testEnvironmentalVariableProvider_byDefault_shouldHaveProcessInfoBeProcessInfoProcessInfo() {
        // Given
        let environmentalVariableProvider = EnvironmentalVariableProvider()
        
        // Then
        XCTAssertTrue(environmentalVariableProvider.processInfo === ProcessInfo.processInfo)
    }
    
    // MARK: Save
    
    func testSave_withReferenceImageDirectoryAsEnvironmentalVariable_shouldCheckIfDirectoryExists() {
        // Given
        let referenceImageDirectoryPathString = "/Environmental/Variable/ReferenceImages"
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: referenceImageDirectoryPathString)
        
        // When
        try? self.sut.save(referenceImage: UIImage(), functionName: "", options: [])
        
        // Then
        XCTAssertEqual(self.fileManagerMock.fileExistsInvokeCount, 1)
        XCTAssertEqual(self.fileManagerMock.fileExistsPathArgument, referenceImageDirectoryPathString)
    }

//    func testSave_withNoSpecifiedReferenceImageDirectory_shouldCheckIfDefaultDirectoryExists() {
//        // When
//        try? self.sut.save(referenceImage: UIImage(), functionName: "", isDeviceAgnostic: false)
//
//        // Then
//        let defaultReferenceImageDirectoryPathString = Bundle(for: type(of: self)).resourcePath?.appending("ReferenceImages")
//        XCTAssertEqual(self.fileManagerMock.fileExistsPathArgument, defaultReferenceImageDirectoryPathString)
//    }

    func testSave_withReferenceImageDirectoryDoesNotExist_shouldCreateDirectory() {
        // Given
        let referenceImageDirectory = "/NonExistingDirectory"
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: referenceImageDirectory)
        self.fileManagerMock.fileExistsReturnValue = false
        
        // When
        try? self.sut.save(referenceImage: UIImage(), functionName: "", options: [])
        
        // Then
        XCTAssertEqual(self.fileManagerMock.createDirectoryInvokeCount, 1)
        XCTAssertEqual(self.fileManagerMock.createDirectoryUrlArgument, URL(string: referenceImageDirectory)!)
    }
    
    func testSave_withReferenceImageDirectoryDoesExist_shouldNotCreateDirectory() {
        // Given
        let referenceImageDirectory = "/ExistingDirectory"
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: referenceImageDirectory)
        self.fileManagerMock.fileExistsReturnValue = true
        
        // When
        try? self.sut.save(referenceImage: UIImage(), functionName: "", options: [])
        
        // Then
        XCTAssertEqual(self.fileManagerMock.createDirectoryInvokeCount, 0)
    }
    
    func testSave_withReferenceImageDirectoryDoesExist_shouldWriteDataToCorrectPath() {
        // Given
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: "/ReferenceImageDirectory")
        self.fileManagerMock.fileExistsReturnValue = true
        let testImage = self.image(for: "redSquare")
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/ReferenceImageDirectory/testFunctionName.png")!)
    }
    
    func testSave_withOptionsModelTypeAndDeviceIsIphone_shouldWriteDataWithCorrectFileName() {
        // Given
        self.configureSutWithExistingReferenceImageDirectory()
        let testImage = self.image(for: "redSquare")
        self.deviceInformationProviderMock.modelReturnValue = "iPhone"
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [.modelType])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/testFunctionName_iPhone.png")!)
    }
    
    func testSave_withOptionsModelTypeAndDeviceIsAppleTV_shouldWriteDataWithCorrectFileName() {
        // Given
        self.configureSutWithExistingReferenceImageDirectory()
        let testImage = self.image(for: "redSquare")
        self.deviceInformationProviderMock.modelReturnValue = "Apple TV"
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [.modelType])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/testFunctionName_AppleTV.png")!)
    }
    
    func testSave_withOptionsOSVersionAndVersionIs11_0_3_shouldWriteDataWithCorrectFileName() {
        // Given
        self.configureSutWithExistingReferenceImageDirectory()
        let testImage = self.image(for: "redSquare")
        self.deviceInformationProviderMock.systemVersionReturnValue = "11.0.3"
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [.osVersion])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/testFunctionName_11_0_3.png")!)
    }
    
    func testSave_withOptionsModelTypeAndOSVersionAndModelTypeIsIpadAndVersionIs10_2_0_shouldWriteDataWithCorrectFileName() {
        // Given
        self.configureSutWithExistingReferenceImageDirectory()
        let testImage = self.image(for: "redSquare")
        self.deviceInformationProviderMock.modelReturnValue = "iPad"
        self.deviceInformationProviderMock.systemVersionReturnValue = "10.2"
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [.modelType, .osVersion])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/testFunctionName_iPad_10_2.png")!)
    }
    
    // MARK: Reference Image
    
    func testReferenceImage_forFunctionName_shouldWriteDataToCorrectPath() {
        // Given
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: "/ReferenceImageDirectory")
        self.fileManagerMock.fileExistsReturnValue = true
        let fileUrl = Bundle(for: type(of: self)).url(forResource: "redSquare", withExtension: "png")
        let data = try? Data(contentsOf: fileUrl!)
        let testImage = UIImage(data: data!, scale: UIScreen.main.scale)!
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", options: [])
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/ReferenceImageDirectory/testFunctionName.png")!)
    }
    
    private func environmentalVariableProviderMock(with referenceImageDirectoryPathString: String) -> EnvironmentalVariableProviderMock {
        let environmentalVariableProviderMock = EnvironmentalVariableProviderMock()
        let referenceImageDirectoryPath = URL(string: referenceImageDirectoryPathString)
        environmentalVariableProviderMock.referenceImageDirectoryReturnValue = referenceImageDirectoryPath
        return environmentalVariableProviderMock
    }
    
    private func image(`for` name: String) -> UIImage {
        let fileUrl = Bundle(for: type(of: self)).url(forResource: name, withExtension: "png")
        let data = try? Data(contentsOf: fileUrl!)
        return UIImage(data: data!, scale: UIScreen.main.scale)!
    }
    
    private func configureSutWithExistingReferenceImageDirectory() {
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: "/")
        self.fileManagerMock.fileExistsReturnValue = true
    }
    
}
