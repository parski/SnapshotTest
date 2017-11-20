//
//  UIImage+Snapshot.swift
//  SnapshotTest
//
//  Copyright © 2017 SnapshotTest. All rights reserved.
//

import UIKit

extension UIImage {

    func normalizedData() -> Data? {

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContext(self.size)

        self.draw(in: CGRect(origin: .zero, size: self.size))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }

        return UIImagePNGRepresentation(image)
    }
}
