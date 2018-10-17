//
//  Wrappable.swift
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

public protocol Configurable : Snapshotable {
    func configured(_ configuration: (Snapshotable) -> Void) -> Snapshotable
}

//extension UICollectionViewCell : Configurable {
//    
//    public func configured(_ configuration: (Snapshotable) -> Void) -> Snapshotable {
//        
//    }
//    
//
//}

public extension Configurable where Self: UICollectionViewCell {
    
    func configured(_ configuration: @escaping (UICollectionViewCell) -> Void) -> Snapshotable {
        let dataSource = WrappingCollectionViewDataSource<Self>(configuration: configuration)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = frame.size
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.reloadData()
        return collectionView
    }
}

public protocol Wrappable {
    associatedtype Wrapper
    func wrapped() -> Wrapper
}

extension UICollectionViewCell : Wrappable {
    public typealias Wrapper = UICollectionView
    
    open func wrapped() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = frame.size
        return UICollectionView(frame: frame, collectionViewLayout: layout)
    }
}

open class WrappingCollectionViewDataSource<CellType: UICollectionViewCell> : NSObject, UICollectionViewDataSource {
    
    private let configuration: ((UICollectionViewCell) -> Void)?
    
    public init(configuration: ((UICollectionViewCell) -> Void)? = nil) {
        self.configuration = configuration
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hi", for: indexPath)
        guard let configuration = configuration else { return cell }
        configuration(cell)
        return cell
    }
}


/*
 
 
 AssertSnapshot(sut.configured { view in
    view.configure(with: bonus)
 })

 
 */
