//
//  TestVectors.swift
//  Blake3Tests
//
//  Created by Khan Winter on 8/9/25.
//

import Testing
import Foundation
@testable import Blake3

private let hashKey: [UInt8] = Array("whats the Elvish word for friend".data(using: .ascii)!)
private let deriveKey = "BLAKE3 2019-12-27 16:29:52 test vectors context"

private struct TestVector: Codable {
    let input_len: Int
    let hash: String
    let keyed_hash: String
    let derive_key: String
}

private func assertVectorMatches(_ vector: TestVector) {
    var baseHash = Blake3()
    applyHash(len: vector.input_len, hasher: &baseHash)
    #expect(baseHash.finalize().hexString == vector.hash.prefix(64), "Vector: \(vector.input_len)")

    var keyedHash = Blake3(key: hashKey)
    applyHash(len: vector.input_len, hasher: &keyedHash)
    #expect(keyedHash.finalize().hexString == vector.keyed_hash.prefix(64), "Vector: \(vector.input_len)")

    var derivedKeyHash = Blake3(deriveKey: deriveKey)
    applyHash(len: vector.input_len, hasher: &derivedKeyHash)
    #expect(derivedKeyHash.finalize().hexString == vector.derive_key.prefix(64), "Vector: \(vector.input_len)")
}

private func applyHash(len: Int, hasher: inout Blake3) {
    for idx in 0..<len {
        let value: UInt8 = UInt8(idx % 251)
        hasher.update(data: [value])
    }
}

@Test("Test Vectors") func testVectors() throws {
    let file = try #require(Bundle.module.url(forResource: "test_vectors", withExtension: "json"))
    let fileData = try Data(contentsOf: file)
    let testVectors = try JSONDecoder().decode([TestVector].self, from: fileData)

    for vector in testVectors {
        assertVectorMatches(vector)
    }
}
