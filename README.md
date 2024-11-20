# BLAKE3 Swift
 
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJoshuaBrest%2Fblake3-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/JoshuaBrest/blake3-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FJoshuaBrest%2Fblake3-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/JoshuaBrest/blake3-swift)

A Swift wrapper for the official C/Rust implementation of BLAKE3.

## License

This project is licensed under the ISC license. See the [LICENSE](LICENSE) file for details.

## Usage

```swift
import BLAKE3

let hasher = BLAKE3()
hasher.update(data: "Hello, world!".data(using: .utf8)!)
let hash = hasher.finalizeData()
print(hash)
```
