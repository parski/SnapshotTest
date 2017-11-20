//
//  SnapshotFileManager.swift
//  POPSnapshotTestCase
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

import Foundation
import UIKit

protocol DataHandling {
    func write(_ data: Data, to path: URL, options: Data.WritingOptions) throws
    func image(from path: URL) -> UIImage?
}

class DataHandler : DataHandling {
    func write(_ data: Data, to path: URL, options: Data.WritingOptions) throws {
        try data.write(to: path, options: options)
    }
    
    func image(from path: URL) -> UIImage? {
        return UIImage(contentsOfFile: path.absoluteString)
    }
}

protocol EnvironmentalVariableProviding {
    func referenceImageDirectory() -> URL?
}

class EnvironmentalVariableProvider : EnvironmentalVariableProviding {
    var processInfo: ProcessInfo = ProcessInfo.processInfo
    
    func referenceImageDirectory() -> URL? {
        guard let environmentReferenceImageDirectory: String = ProcessInfo.processInfo.environment["POP_REFERENCE_IMAGE_DIR"] else { return nil }
        
        return URL(fileURLWithPath: environmentReferenceImageDirectory)
    }
}

protocol SnapshotFileManaging {
    func save(referenceImage: UIImage, functionName: String, isDeviceAgnostic: Bool) throws
    func referenceImage(forFunctionName functionName: String, isDeviceAgnostic: Bool) throws -> UIImage
}

enum SnapshotFileManagerError : Error {
    case unableToDetermineReferenceImageDirectory
    case unableToSerializeReferenceImage
    case unableToDeserializeReferenceImage
}

class SnapshotFileManager : SnapshotFileManaging {
    
    var fileManager: FileManager = FileManager.default
    var dataHandler: DataHandling = DataHandler()
    var environmentalVariableProvider: EnvironmentalVariableProviding = EnvironmentalVariableProvider()
    
    lazy var referenceImageDirectory: URL? = {
        self.environmentalVariableProvider.referenceImageDirectory()
    }()
    
    func save(referenceImage: UIImage, functionName: String, isDeviceAgnostic: Bool) throws {
        guard let referenceImageDirectory = self.referenceImageDirectory else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }
        if self.fileManager.fileExists(atPath: referenceImageDirectory.absoluteString) == false {
            try self.fileManager.createDirectory(at: referenceImageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        let path = try self.path(forFunctionName: functionName, isDeviceAgnostic: isDeviceAgnostic)
        guard let imagePngData = UIImagePNGRepresentation(referenceImage) else { throw SnapshotFileManagerError.unableToSerializeReferenceImage }
        try self.dataHandler.write(imagePngData, to: path, options: .atomicWrite)
    }
    
    func referenceImage(forFunctionName functionName: String, isDeviceAgnostic: Bool) throws -> UIImage {
        let path = try self.path(forFunctionName: functionName, isDeviceAgnostic: isDeviceAgnostic)
        guard let referenceImage = self.dataHandler.image(from: path) else { throw SnapshotFileManagerError.unableToDeserializeReferenceImage }
        
        return referenceImage
    }
    
    private func path(forFunctionName functionName: String, isDeviceAgnostic: Bool) throws -> URL {
        guard let referenceImageDirectory = referenceImageDirectory else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }
        let fileName = self.filename(forFunctionName: functionName, isDeviceAgnostic: isDeviceAgnostic)
        
        return referenceImageDirectory.appendingPathComponent(fileName).appendingPathExtension("png")
    }
    
    private func filename(forFunctionName functionName: String, isDeviceAgnostic: Bool) -> String {
        guard isDeviceAgnostic else { return functionName }
        
        return functionName.appending(self.deviceAgnosticSegment())
    }
    
    private func deviceAgnosticSegment() -> String {
        return "_"
    }
    
}
