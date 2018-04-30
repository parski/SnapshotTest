//
//  UIImage+Compare.swift
//  SnapshotTest
//
//  Copyright © 2018 SnapshotTest. All rights reserved.
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
//
// Based on https://github.com/uber/ios-snapshot-test-case/blob/master/FBSnapshotTestCase/Categories/UIImage%2BCompare.m
//

import UIKit
import CoreGraphics

extension UIImage {

    func compare(withImage image: UIImage) -> Bool {
        guard let selfCgImage = cgImage else { return false }
        guard let imageCgImage = image.cgImage else { return false }
        return selfCgImage.compare(withImage: imageCgImage)
    }
}

private extension CGImage {

    private var size: CGSize {
        return CGSize(width: self.width, height: self.height)
    }

    func compare(withImage image: CGImage) -> Bool {

        guard size.equalTo(image.size) else { return false }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let minBytesPerRow = min(bytesPerRow, image.bytesPerRow)

        let imageSizeBytes = height * minBytesPerRow
        var imageBuf = Array<CUnsignedChar>(repeating: 0, count: imageSizeBytes)
        var referenceBuf = Array<CUnsignedChar>(repeating: 0, count: imageSizeBytes)

        guard let imageContext = CGContext(data: &imageBuf, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: minBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return false
        }

        guard let referenceContext = CGContext(data: &referenceBuf, width: image.width, height: image.height, bitsPerComponent: image.bitsPerComponent, bytesPerRow: minBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return false
        }

        imageContext.draw(self, in: CGRect(origin: .zero, size: size))
        referenceContext.draw(image, in: CGRect(origin: .zero, size: image.size))

        return memcmp(UnsafePointer(imageBuf), UnsafePointer(referenceBuf), imageSizeBytes) == 0
    }
}
