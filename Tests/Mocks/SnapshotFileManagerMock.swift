//
//  SnapshotFileManagerMock.swift
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
import Foundation
import UIKit

class SnapshotFileManagerMock : SnapshotFileManaging {
    
    var saveInvokeCount: Int = 0
    var saveReferenceImageArgument: UIImage? = nil
    var saveFunctionNameArgument: String? = nil
    var saveOptionsArgument: DeviceOptions? = nil
    var saveErrorToThrow: Error? = nil
    
    var referenceImageInvokeCount: Int = 0
    var referenceImageFunctionNameArgument: String? = nil
    var referenceImageOptionsArgument: DeviceOptions? = nil
    var referenceImageErrorToThrow: Error? = nil
    var referenceImageReturnValue: UIImage? = nil
    
    func save(referenceImage: UIImage, functionName: String, options: DeviceOptions) throws {
        self.saveInvokeCount += 1
        self.saveReferenceImageArgument = referenceImage
        self.saveFunctionNameArgument = functionName
        self.saveOptionsArgument = options
        if let error = self.saveErrorToThrow { throw error }
    }
    
    func referenceImage(forFunctionName functionName: String, options: DeviceOptions) throws -> UIImage {
        self.referenceImageInvokeCount += 1
        self.referenceImageFunctionNameArgument = functionName
        self.referenceImageOptionsArgument = options
        if let error = self.referenceImageErrorToThrow { throw error }
        return self.referenceImageReturnValue ?? UIImage()
    }
    
    
}
