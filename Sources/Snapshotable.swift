//
//  Snapshotable.swift
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

import UIKit

public protocol Snapshotable {
    func snapshot() -> UIImage?
}

extension CALayer : Snapshotable {

    public func snapshot() -> UIImage? {

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        render(in: context)

        let image = UIGraphicsGetImageFromCurrentImageContext()

        return image
    }
}

extension UIView : Snapshotable {

    public func snapshot() -> UIImage? {
        layoutIfNeeded()
        return layer.snapshot()
    }
}

extension UIViewController : Snapshotable {

    public func snapshot() -> UIImage? {
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
        return view.snapshot()
    }
}
