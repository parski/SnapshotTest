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

import UIKit

protocol ProcessEnvironment : AnyObject {
    var environment: [String : String] { get }
}

extension ProcessInfo : ProcessEnvironment {}

protocol DataHandling {
    func write(_ data: Data, to path: URL, options: Data.WritingOptions) throws
    func image(from path: URL) -> UIImage?
}

class DataHandler : DataHandling {
    func write(_ data: Data, to path: URL, options: Data.WritingOptions) throws {
        try data.write(to: path, options: options)
    }
    
    func image(from path: URL) -> UIImage? {
        guard let data = try? Data.init(contentsOf: path) else { return nil }
        return UIImage(data: data, scale: UIScreen.main.scale)
    }
}

protocol SnapshotFileManaging {
    func save(referenceImage: UIImage, filename: String, className: String) throws -> URL
    func referenceImage(filename: String, className: String) throws -> UIImage
}

enum SnapshotFileManagerError : Error {
    case unableToDetermineReferenceImageDirectory
    case unableToSerializeReferenceImage
    case unableToDeserializeReferenceImage
}

extension SnapshotFileManagerError : Equatable {
    static func ==(lhs: SnapshotFileManagerError, rhs: SnapshotFileManagerError) -> Bool {
        switch (lhs, rhs) {
        case (.unableToDetermineReferenceImageDirectory, .unableToDetermineReferenceImageDirectory):
            return true
        case (.unableToSerializeReferenceImage, .unableToSerializeReferenceImage):
            return true
        case (.unableToDeserializeReferenceImage, .unableToDeserializeReferenceImage):
            return true
        default:
            return false
        }
    }
}

class SnapshotFileManager {
    
    let fileManager: FileManager
    let dataHandler: DataHandling
    let processInfo: ProcessEnvironment

    init(
        fileManager: FileManager = FileManager.default,
        dataHandler: DataHandling = DataHandler(),
        processInfo: ProcessEnvironment = ProcessInfo.processInfo
    ) {
        self.fileManager = fileManager
        self.dataHandler = dataHandler
        self.processInfo = processInfo
    }
    
    lazy var referenceImageDirectory: URL? = {
        guard let environmentReferenceImageDirectory = processInfo.environment["REFERENCE_IMAGE_DIR"] else { return nil }
        return URL(fileURLWithPath: environmentReferenceImageDirectory)
    }()
    
    private func buildAbsolutePath(for filename: String, className: String) throws -> URL {
        guard let referenceImageDirectory = referenceImageDirectory else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }

        return referenceImageDirectory
            .appendingPathComponent(className)
            .appendingPathComponent(filename)
            .appendingPathExtension("png")
    }
}

extension SnapshotFileManager : SnapshotFileManaging {

    @discardableResult
    func save(referenceImage: UIImage, filename: String, className: String) throws -> URL {
        guard let referenceImageDirectory = referenceImageDirectory?.appendingPathComponent(className) else { throw SnapshotFileManagerError.unableToDetermineReferenceImageDirectory }
        if fileManager.fileExists(atPath: referenceImageDirectory.absoluteString) == false {
            try fileManager.createDirectory(at: referenceImageDirectory, withIntermediateDirectories: true, attributes: nil)
        }

        let path = try buildAbsolutePath(for: filename, className: className)
        guard let imagePngData = referenceImage.pngData() else { throw SnapshotFileManagerError.unableToSerializeReferenceImage }
        try dataHandler.write(imagePngData, to: path, options: .atomicWrite)
        return path
    }

    func referenceImage(filename: String, className: String) throws -> UIImage {
        let path = try buildAbsolutePath(for: filename, className: className)
        guard let referenceImage = dataHandler.image(from: path) else { throw SnapshotFileManagerError.unableToDeserializeReferenceImage }

        return referenceImage
    }
}
