//
//  SnapshotFileManagerMock.swift
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
import UIKit

class SnapshotFileManagerMock : SnapshotFileManaging {

    var saveInvokeCount: Int = 0
    var saveReferenceImageArgument: UIImage?
    var saveFilenameArgument: String?
    var saveClassNameArgument: String?
    var saveErrorToThrow: Error?
    var saveReturnValue: URL?
    
    var referenceImageInvokeCount: Int = 0
    var referenceImageFilenameArgument: String?
    var referenceImageClassNameArgument: String?
    var referenceImageErrorToThrow: Error?
    var referenceImageReturnValue: UIImage?
    
    func save(referenceImage: UIImage, filename: String, className: String) throws -> URL {
        saveInvokeCount += 1
        saveReferenceImageArgument = referenceImage
        saveFilenameArgument = filename
        saveClassNameArgument = className
        if let error = saveErrorToThrow { throw error }
        return saveReturnValue ?? URL(fileURLWithPath: "/")
    }
    
    func referenceImage(filename: String, className: String) throws -> UIImage {
        referenceImageInvokeCount += 1
        referenceImageFilenameArgument = filename
        referenceImageClassNameArgument = className
        if let error = referenceImageErrorToThrow { throw error }
        return referenceImageReturnValue ?? UIImage()
    }
}
