import Foundation
import blake3_c

public final class Blake3 {
    private static let BLAKE3_OUT_LENGTH: Int = Int(BLAKE3_OUT_LEN)

    private var hasher: blake3_hasher

    public init() {
        hasher = blake3_hasher()
        blake3_hasher_init(&hasher)
    }

    public func update(bytes: UnsafeRawBufferPointer) {
        blake3_hasher_update(&hasher, bytes.baseAddress, bytes.count)
    }

    public func update(buffer: [UInt8]) {
        buffer.withUnsafeBufferPointer { ptr in
            update(bytes: UnsafeRawBufferPointer(ptr))
        }
    }

    public func update(data: Data) {
        update(bytes: data.withUnsafeBytes { $0 })
    }

    public func finalizeBytes() -> [UInt8] {
        var out = [UInt8](repeating: 0, count: Blake3.BLAKE3_OUT_LENGTH)
        blake3_hasher_finalize(&hasher, &out, Blake3.BLAKE3_OUT_LENGTH)
        return out
    }

    public func finalizeData() -> Data {
        return Data(bytes: finalizeBytes())
    }
}
