//
//  SnapshotFileManager.swift
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

protocol DeviceInformationProviding {
    var model: String { get }
    var systemVersion: String { get }
}

class DeviceInformationProvider : DeviceInformationProviding {

    var model: String {
        return UIDevice.current.model
    }
    
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
}

protocol SnapshotFileManaging {
    func save(referenceImage: UIImage, functionName: String, options: DeviceOptions) throws
    func referenceImage(forFunctionName functionName: String, options: DeviceOptions) throws -> UIImage
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
    var deviceInformationProvider: DeviceInformationProviding = DeviceInformationProvider()
    
    lazy var referenceImageDirectory: URL? = {
        self.environmentalVariableProvider.referenceImageDirectory()
    }()
    
    func save(referenceImage: UIImage, functionName: String, options: DeviceOptions) throws {
        guard let referenceImageDirectory = self.referenceImageDirectory else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }
        if self.fileManager.fileExists(atPath: referenceImageDirectory.absoluteString) == false {
            try self.fileManager.createDirectory(at: referenceImageDirectory, withIntermediateDirectories: true, attributes: nil)
        }
        
        let path = try self.path(forFunctionName: functionName, options: options)
        guard let imagePngData = UIImagePNGRepresentation(referenceImage) else { throw SnapshotFileManagerError.unableToSerializeReferenceImage }
        try self.dataHandler.write(imagePngData, to: path, options: .atomicWrite)
    }
    
    func referenceImage(forFunctionName functionName: String, options: DeviceOptions) throws -> UIImage {
        let path = try self.path(forFunctionName: functionName, options: options)
        guard let referenceImage = self.dataHandler.image(from: path) else { throw SnapshotFileManagerError.unableToDeserializeReferenceImage }
        
        return referenceImage
    }
    
    private func path(forFunctionName functionName: String, options: DeviceOptions) throws -> URL {
        guard let referenceImageDirectory = referenceImageDirectory else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }
        let fileName = self.filename(forFunctionName: functionName, options: options)
        
        return referenceImageDirectory.appendingPathComponent(fileName).appendingPathExtension("png")
    }
    
    private func filename(forFunctionName functionName: String, options: DeviceOptions) -> String {
        guard options.isEmpty == false else { return functionName }
        
        return functionName.appending(self.segment(for: options))
    }
    
    private func segment(for options: DeviceOptions) -> String {
        var segment = ""
        
        if options.contains(.modelType) {
            segment.append(self.typeSegment())
        }
        
        if options.contains(.osVersion) {
            segment.append(self.osVersionSegment())
        }
        
        return segment
    }
    
    private func typeSegment() -> String {
        let model = self.deviceInformationProvider.model
        let formattedModel = model.components(separatedBy: .whitespaces).joined()
        
        return "_\(formattedModel)"
    }
    
    private func osVersionSegment() -> String {
        let version = self.deviceInformationProvider.systemVersion
        let formattedVersion = version.replacingOccurrences(of: ".", with: "_")
        
        return "_\(formattedVersion)"
    }
    
}
