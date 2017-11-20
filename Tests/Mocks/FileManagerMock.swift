//
//  POPFileManagerMock.swift
//  POPSnapshotTestCaseTests
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
import Foundation

class FileManagerMock : FileManager {
    
    var fileExistsInvokeCount: Int = 0
    var fileExistsPathArgument: String? = nil
    var fileExistsReturnValue: Bool = false
    
    var createDirectoryInvokeCount: Int = 0
    var createDirectoryUrlArgument:  URL? = nil
    var createDirectoryCreateIntermediariesArgument: Bool? = nil
    var createDirectoryErrorToThrow: Error? = nil
    
    override func fileExists(atPath path: String) -> Bool {
        self.fileExistsInvokeCount += 1
        self.fileExistsPathArgument = path
        return self.fileExistsReturnValue
    }
    
    override func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]? = nil) throws {
        self.createDirectoryInvokeCount += 1
        self.createDirectoryUrlArgument = url
        self.createDirectoryCreateIntermediariesArgument = createIntermediates
        if let error = self.createDirectoryErrorToThrow { throw error }
    }
    
}
