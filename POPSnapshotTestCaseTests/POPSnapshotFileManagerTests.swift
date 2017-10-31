//
//  POPSnapshotFileManagerTests.swift
//  POPSnapshotTestCaseTests
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

import XCTest

class POPSnapshotFileManagerTests: XCTestCase {
    
    var sut: POPSnapshotFileManager!
    
    var fileManagerMock: POPFileManagerMock!
    var dataHandlerMock: POPDataHandlerMock!
    
    override func setUp() {
        super.setUp()
        self.sut = POPSnapshotFileManager()
        self.fileManagerMock = POPFileManagerMock()
        self.sut.fileManager = fileManagerMock
        self.dataHandlerMock = POPDataHandlerMock()
        self.sut.dataHandler = self.dataHandlerMock
    }
    
    override func tearDown() {
        self.sut = nil
        self.fileManagerMock = nil
        self.dataHandlerMock = nil
        super.tearDown()
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveFileManagerBeDefaultFileManager() {
        // Given
        self.sut = POPSnapshotFileManager()
        
        // Then
        XCTAssert(self.sut.fileManager === FileManager.default)
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveDataWriterBeInstanceOfPOPDataWriter() {
        // Given
        self.sut = POPSnapshotFileManager()
        
        // Then
        XCTAssertTrue(self.sut.dataHandler as? POPDataHandler != nil)
    }
    
    func testSnapshotFileManager_byDefault_shouldHaveEnvironmentalVariableProviderBeInstanceOfEnvironmentalVariableProvider() {
        // Given
        self.sut = POPSnapshotFileManager()
        
        // Then
        XCTAssertTrue(self.sut.environmentalVariableProvider as? POPEnvironmentalVariableProvider != nil)
    }
    
    // MARK: Environmental Variable Provider
    
    func testEnvironmentalVariableProvider_byDefault_shouldHaveProcessInfoBeProcessInfoProcessInfo() {
        // Given
        let environmentalVariableProvider = POPEnvironmentalVariableProvider()
        
        // Then
        XCTAssertTrue(environmentalVariableProvider.processInfo === ProcessInfo.processInfo)
    }
    
    // MARK: Save
    
    func testSave_withReferenceImageDirectoryAsEnvironmentalVariable_shouldCheckIfDirectoryExists() {
        // Given
        let referenceImageDirectoryPathString = "/Environmental/Variable/ReferenceImages"
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: referenceImageDirectoryPathString)
        
        // When
        try? self.sut.save(referenceImage: UIImage(), functionName: "", isDeviceAgnostic: false)
        
        // Then
        XCTAssertEqual(self.fileManagerMock.fileExistsInvokeCount, 1)
        XCTAssertEqual(self.fileManagerMock.fileExistsPathArgument, referenceImageDirectoryPathString)
    }
    
    func testSave_withReferenceImageDirectoryDoesNotExist_shouldCreateDirectory() {
        // Given
        let referenceImageDirectory = "/NonExistingDirectory"
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: referenceImageDirectory)
        self.fileManagerMock.fileExistsReturnValue = false
        
        // When
        try? self.sut.save(referenceImage: UIImage(), functionName: "", isDeviceAgnostic: false)
        
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
        try? self.sut.save(referenceImage: UIImage(), functionName: "", isDeviceAgnostic: false)
        
        // Then
        XCTAssertEqual(self.fileManagerMock.createDirectoryInvokeCount, 0)
    }
    
    func testSave_withReferenceImageDirectoryDoesExist_shouldWriteDataToCorrectPath() {
        // Given
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: "/ReferenceImageDirectory")
        self.fileManagerMock.fileExistsReturnValue = true
        let testImage = UIImage(named: "redSquare", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", isDeviceAgnostic: false)
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/ReferenceImageDirectory/testFunctionName.png")!)
    }
    
    // MARK: Reference Image
    
    func testReferenceImage_forFunctionName_shouldWriteDataToCorrectPath() {
        // Given
        self.sut.environmentalVariableProvider = self.environmentalVariableProviderMock(with: "/ReferenceImageDirectory")
        self.fileManagerMock.fileExistsReturnValue = true
        let testImage = UIImage(named: "redSquare", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        
        // When
        try? self.sut.save(referenceImage: testImage, functionName: "testFunctionName", isDeviceAgnostic: false)
        
        // Then
        XCTAssertEqual(self.dataHandlerMock.writeInvokeCount, 1)
        XCTAssertEqual(self.dataHandlerMock.writePathArgument, URL(string: "/ReferenceImageDirectory/testFunctionName.png")!)
    }
    
    private func environmentalVariableProviderMock(with referenceImageDirectoryPathString: String) -> POPEnvironmentalVariableProviderMock {
        let environmentalVariableProviderMock = POPEnvironmentalVariableProviderMock()
        let referenceImageDirectoryPath = URL(string: referenceImageDirectoryPathString)
        environmentalVariableProviderMock.referenceImageDirectoryReturnValue = referenceImageDirectoryPath
        return environmentalVariableProviderMock
    }
    
}
