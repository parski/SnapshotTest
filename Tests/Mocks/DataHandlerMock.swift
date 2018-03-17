//
//  DataHandlerMock.swift
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

class DataHandlerMock : DataHandling {
    
    var writeInvokeCount: Int = 0
    var writeDataArgument: Data? = nil
    var writePathArgument: URL? = nil
    var writeOptionsArgument: Data.WritingOptions? = nil
    var writeErrorToThrow: Error? = nil
    
    var imageInvokeCount: Int = 0
    var imagePathArgument: URL? = nil
    var imageReturnValue: UIImage? = nil
    
    func write(_ data: Data, to path: URL, options: Data.WritingOptions) throws {
        writeInvokeCount += 1
        writeDataArgument = data
        writePathArgument = path
        writeOptionsArgument = options
        if let error = writeErrorToThrow { throw error }
    }
    
    func image(from path: URL) -> UIImage? {
        imageInvokeCount += 1
        imagePathArgument = path
        return imageReturnValue
    }
    
}
