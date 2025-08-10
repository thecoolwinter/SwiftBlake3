//
//  PrettyBytes.swift
//  SwiftBlake3
//
//  Created by Khan Winter on 8/9/25.
//

// Taken mostly from swift-collections

import Foundation
@testable import Blake3

let charA = UInt8(UnicodeScalar("a").value)
let char0 = UInt8(UnicodeScalar("0").value)

private func itoh(_ value: UInt8) -> UInt8 {
    return (value > 9) ? (charA + value - 10) : (char0 + value)
}

private func htoi(_ value: UInt8) throws -> UInt8 {
    switch value {
    case char0...char0 + 9:
        return value - char0
    case charA...charA + 5:
        return value - charA + 10
    default:
        fatalError()
    }
}

extension MutableDataProtocol {
    mutating func appendByte(_ byte: UInt64) {
        withUnsafePointer(to: byte.littleEndian, { self.append(contentsOf: UnsafeRawBufferPointer(start: $0, count: 8)) })
    }
}

extension Blake3Digest {
    var toArray: [UInt8] {
        var array = [UInt8]()
        array.appendByte(bytes.0)
        array.appendByte(bytes.1)
        array.appendByte(bytes.2)
        array.appendByte(bytes.3)
        return array
    }

    var hexString: String {
        var hexChars = [UInt8](repeating: 0, count: Self.byteCount * 2)

        for (idx, byte) in toArray.enumerated() {
            hexChars[Int(idx * 2)] = itoh((byte >> 4) & 0xF)
            hexChars[Int(idx * 2 + 1)] = itoh(byte & 0xF)
        }

        return String(bytes: hexChars, encoding: .utf8)!
    }
}
