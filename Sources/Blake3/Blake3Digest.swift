//
//  Blake3Digest.swift
//  BLAKE3
//
//  Created by Khan Winter on 8/9/25.
//

import Crypto
import blake3_c

public struct Blake3Digest: Digest {
    public static var byteCount: Int { Int(BLAKE3_OUT_LEN) }

    var bytes: (UInt64, UInt64, UInt64, UInt64)

    init() {
        bytes = (0, 0, 0, 0)
    }

    init(_ body: (UnsafeMutablePointer<UInt8>) -> Void) {
        self.init()
        withUnsafeMutablePointer(to: &bytes) { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: Self.byteCount) { bytePointer in
                body(bytePointer)
            }
        }
    }

    public func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        return try Swift.withUnsafeBytes(of: bytes) {
            let boundsCheckedPtr = UnsafeRawBufferPointer(
                start: $0.baseAddress,
                count: Self.byteCount
            )
            return try body(boundsCheckedPtr)
        }
    }

    public func hash(into hasher: inout Hasher) {
        self.withUnsafeBytes { hasher.combine(bytes: $0) }
    }
}
