# BLAKE3

A Swift wrapper for the official C/Rust implementation of BLAKE3.

## License

This project is licensed under the ISC license. See the [LICENSE](LICENSE.md) file for details.

## Usage

```swift
import BLAKE3

let hasher = BLAKE3()
hasher.update(data: "Hello, world!".data(using: .utf8)!)
let hash = hasher.finalizeData()
print(hash)
```
