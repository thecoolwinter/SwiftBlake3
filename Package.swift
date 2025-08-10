// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if os(WASI)
let dependencies: [Package.Dependency] = []
let packageDependencies: [Target.Dependency] = []
#else
let dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "4.0.0"),
]
let packageDependencies: [Target.Dependency] = [
    "blake3-c",
    .product(name: "Crypto", package: "swift-crypto")
]
#endif

let package = Package(
    name: "SwiftBlake3",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .macCatalyst(.v13),
        .watchOS(.v6),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Blake3",
            targets: ["Blake3"]
        ),
    ],
    dependencies: dependencies,
    targets: [
        .target(
            name: "blake3-c",
            cSettings: [
                .headerSearchPath("./lib/blake3/include")
            ]
        ),
        .target(
            name: "Blake3",
            dependencies: packageDependencies
        ),
        .testTarget(
            name: "Blake3Tests",
            dependencies: ["Blake3"],
            resources: [.copy("test_vectors.json")]
        ),
        .executableTarget(name: "Benchmarks", dependencies: ["Blake3"]),
    ]
)
