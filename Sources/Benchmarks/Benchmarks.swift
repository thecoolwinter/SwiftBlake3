import Foundation
import Crypto
import Blake3

@_optimize(none)
func blackHole<T>(_ t: T) {}

/// Benchmark a `HashFunction` type from Swift Crypto
func benchmark<H: HashFunction>(
    _ name: String,
    hashFunction: H.Type,
    iterations: Int,
    dataSize: Int
) {
    // Prepare random data
    let data = (0..<dataSize).map { _ in UInt8.random(in: 0...UInt8.max) }

    // Timer
    var info = mach_timebase_info()
    guard mach_timebase_info(&info) == KERN_SUCCESS else { fatalError() }
    let start = mach_absolute_time()

    for _ in 0..<iterations {
        var hasher = H()
        hasher.update(data: data)
        blackHole(hasher.finalize())
    }

    let end = mach_absolute_time()
    let elapsed = end - start
    let nanos = elapsed * UInt64(info.numer) / UInt64(info.denom)
    let sec = TimeInterval(nanos) / TimeInterval(NSEC_PER_SEC)

    // Throughput
    let totalBytes = Double(dataSize) * Double(iterations)            // total bytes hashed
    let mbps = (totalBytes / 1_048_576.0) / sec                       // MB/s (MiB-based)

    print("\(name): \(String(format: "%.6f", sec))s total, \(String(format: "%.1f", mbps)) MB/s")
}

@main
struct Main {
    static func main() {
        print("64 bytes")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 64)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 64)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 64)

        print("256 bytes")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 512)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 512)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 512)

        print("512 bytes")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 512)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 512)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 512)

        print("1kb")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 1024)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 1024)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 1024)

        print("16kb")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 1024 * 16)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 1024 * 16)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 1024 * 16)

        print("48kb")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 1024 * 48)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 1024 * 48)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 1024 * 48)

        print("1Mb")
        benchmark("SHA256", hashFunction: SHA256.self, iterations: 1024 * 16, dataSize: 1024 * 1024)
        benchmark("SHA512", hashFunction: SHA512.self, iterations: 1024 * 16, dataSize: 1024 * 1024)
        benchmark("Blake3", hashFunction: Blake3.self, iterations: 1024 * 16, dataSize: 1024 * 1024)
    }
}
