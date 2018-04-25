//
//  SnapshotCoordinator.swift
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

protocol SnapshotCoordinating {
    func compareSnapshot(of view: UIView, options: Options, functionName: String, line: UInt) throws
    func recordSnapshot(of view: UIView, options: Options, functionName: String, line: UInt) throws
}

struct SnapshotCoordinator {

    let className: String
    let fileManager: SnapshotFileManaging
    let filenameFormatter: FilenameFormatting

    init(className: String, fileManager: SnapshotFileManaging = SnapshotFileManager(), filenameFormatter: FilenameFormatting = FilenameFormatter()) {
        self.className = className
        self.fileManager = fileManager
        self.filenameFormatter = filenameFormatter
    }

    private func image(forView view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        view.layoutIfNeeded()
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

extension SnapshotCoordinator : SnapshotCoordinating {

    func compareSnapshot(of view: UIView, options: Options = [], functionName: String, line: UInt) throws {
        guard let snapshot = image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }

        let filename = filenameFormatter.format(functionName: functionName, options: options)
        let referenceImage = try fileManager.referenceImage(filename: filename, className: className)

        guard snapshot.normalizedData() == referenceImage.normalizedData() else {
            throw SnapshotError.imageMismatch(filename: filename)
        }
    }

    func recordSnapshot(of view: UIView, options: Options = [], functionName: String, line: UInt) throws {
        guard let referenceImage = image(forView: view) else { throw SnapshotError.unableToTakeSnapshot }
        let filename = filenameFormatter.format(functionName: functionName, options: options)
        try fileManager.save(referenceImage: referenceImage, filename: filename, className: className)
    }
}
