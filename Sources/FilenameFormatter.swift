//
//  FilenameFormatter.swift
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


protocol FilenameFormatting {
    func format(sourceFile: StaticString, functionName: String, options: Options) -> String
}

class FilenameFormatter {

    let device: UIDevice

    lazy var deviceModel: String = {
        return device.model.components(separatedBy: .whitespaces).joined()
    }()

    lazy var systemVersion: String = {
        return device.systemVersion.replacingOccurrences(of: ".", with: "_")
    }()

    init(device: UIDevice = .current) {
        self.device = device
    }
}

extension FilenameFormatter : FilenameFormatting {

    func format(sourceFile: StaticString, functionName: String, options: Options) -> String {
        let file = URL(fileURLWithPath: sourceFile.description).lastPathComponent.removeExtension()
        var components: [String] = [file, functionName.formatted()]

        if options.contains(.device) {
            components.append(deviceModel)
        }

        if options.contains(.osVersion) {
            components.append(systemVersion)
        }

        return components.joined(separator: "_")
    }
}

private extension String {

    func removeExtension() -> String {
        let string = self as NSString
        return string.deletingPathExtension
    }

    func formatted() -> String {
        let validCharacters = CharacterSet(charactersIn: "()").inverted

        return String(describing: self.unicodeScalars.filter { unicodeScalar -> Bool in
            return validCharacters.contains(unicodeScalar)
        })
    }
}

