import Foundation
import blake3_c

public final class Blake3 {
    private let hasher: blake3_hasher

    public init() {
        hasher = blake3_hasher()
        blake3_hasher_init(&hasher)
    }

    public func update(bytes: UnsafeRawBufferPointer) {
        blake3_hasher_update(&hasher, bytes.baseAddress, bytes.count)
    }

    public func update(buffer: [UInt8]) {
        update(bytes: buffer)
    }

    public func update(data: Data) {
        update(bytes: data.withUnsafeBytes { $0 })
    }

    public func finalizeBytes() -> UnsafeRawBufferPointer {
        var out = [UInt8](repeating: 0, count: BLAKE3_OUT_LEN)
        blake3_hasher_finalize(&hasher, &out, BLAKE3_OUT_LEN)
        return UnsafeRawBufferPointer(start: out, count: BLAKE3_OUT_LEN)
    }

    public func finalizeBuffer() -> [UInt8] {
        return finalizeBytes().bindMemory(to: UInt8.self).map { $0 }
    }

    public func finalizeData() -> Data {
        return Data(bytes: finalizeBytes())
    }
}
