//
//  CoWTests.swift
//  BLAKE3
//
//  Created by Khan Winter on 8/9/25.
//

import Testing
@testable import Blake3

@Test("Valid CoW") func validCoW() {
    var hf = Blake3()
    hf.update(data: [1, 2, 3, 4])

    var hfCopy = hf
    hf.update(data: [5, 6, 7, 8])
    let digest = hf.finalize()

    hfCopy.update(data: [5, 6, 7, 8])
    let copyDigest = hfCopy.finalize()

    #expect(digest == copyDigest)
}
