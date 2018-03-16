//
//  Options.swift
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

public struct Options {

    private var array: [Option] = []
    private var set: Set<Option> = []

    public var count: Int { return array.count }
    public var isEmpty: Bool { return array.isEmpty }

    public init(_ array: [Option]) {
        for element in array {
            append(element)
        }
    }

    @discardableResult
    public mutating func append(_ newElement: Option) -> Bool {
        let inserted = set.insert(newElement).inserted
        if inserted {
            array.append(newElement)
        }
        return inserted
    }
}

extension Options : Sequence {

    public func contains(_ member: Option) -> Bool {
        return set.contains(member)
    }
}

extension Options : ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: Option...) {
        self.init(elements)
    }
}

extension Options: RandomAccessCollection {

    public var startIndex: Int { return array.startIndex }
    public var endIndex: Int { return array.endIndex }
    public subscript(index: Int) -> Option {
        return array[index]
    }
}
