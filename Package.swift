// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BLAKE3",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "BLAKE3",
            targets: ["BLAKE3"]),
    ],
    targets: [
        .target(
            name: "blake3-c",
            cSettings: [
                .headerSearchPath("./lib/blake3/include")
            ]),
        .target(
            name: "BLAKE3",
            dependencies: ["blake3-c"])
    ]
)
