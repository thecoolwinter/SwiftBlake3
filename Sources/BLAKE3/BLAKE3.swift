import Foundation
import blake3_c

/// A BLAKE3 hasher.
/// Usage:
/// ```swift
/// let hasher = BLAKE3()
/// hasher.update(data: "Hello, world!".data(using: .utf8)!)
/// let hash = hasher.finalizeData()
/// print(hash)
/// ```
public final class BLAKE3 {
    private static let BLAKE3_OUT_LENGTH: Int = Int(BLAKE3_OUT_LEN)

    private var hasher: blake3_hasher

    /// Initialize a new BLAKE3 hasher.
    public init() {
        hasher = blake3_hasher()
        blake3_hasher_init(&hasher)
    }

    /// Update the hasher with a pointer to a buffer of bytes.
    /// - Parameter bytes: A pointer to a buffer of bytes.
    /// Usage:
    /// ```swift
    /// let data = "Hello, world!".data(using: .utf8)!
    /// hasher.update(bytes: data.withUnsafeBytes { $0 })
    /// ```
    /// Note: Prefer using `update(buffer:)` or `update(data:)` over this.
    public func update(bytes: UnsafeRawBufferPointer) {
        blake3_hasher_update(&hasher, bytes.baseAddress, bytes.count)
    }

    /// Update the hasher with a buffer of bytes.
    /// - Parameter buffer: A buffer of bytes.
    /// Usage:
    /// ```swift
    /// let data = "Hello, world!".data(using: .utf8)!
    /// hasher.update(buffer: [UInt8](data))
    /// ```
    public func update(buffer: [UInt8]) {
        buffer.withUnsafeBufferPointer { ptr in
            update(bytes: UnsafeRawBufferPointer(ptr))
        }
    }

    /// Update the hasher with a `Data` object. This is the most common usage.
    /// - Parameter data: A `Data` object.
    /// Usage:
    /// ```swift
    /// let data = "Hello, world!".data(using: .utf8)!
    /// hasher.update(data: data)
    /// ```
    public func update(data: Data) {
        data.withUnsafeBytes { update(bytes: $0 )  }
    }

    /// Finalize the hasher and return the hash as a buffer of bytes.
    /// - Returns: A buffer of bytes.
    /// Usage:
    /// ```swift
    /// let data = "Hello, world!".data(using: .utf8)!
    /// hasher.update(data: data)
    /// let hash = hasher.finalizeBytes() // [UInt8]
    /// print(hash)
    /// ```
    public func finalizeBytes() -> [UInt8] {
        var out = [UInt8](repeating: 0, count: BLAKE3.BLAKE3_OUT_LENGTH)
        blake3_hasher_finalize(&hasher, &out, BLAKE3.BLAKE3_OUT_LENGTH)
        return out
    }

    /// Finalize the hasher and return the hash as a `Data` object.
    /// - Returns: A `Data` object.
    /// Usage:
    /// ```swift
    /// let data = "Hello, world!".data(using: .utf8)!
    /// hasher.update(data: data)
    /// let hash = hasher.finalizeData() // Data
    /// print(hash)
    /// ```
    public func finalizeData() -> Data {
        return Data(finalizeBytes())
    }
}
