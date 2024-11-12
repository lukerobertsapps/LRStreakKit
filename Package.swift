// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LRStreakKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "LRStreakKit",
            targets: ["LRStreakKit"]
        ),
    ],
    targets: [
        .target(name: "LRStreakKit"),
        .testTarget(
            name: "LRStreakKitTests",
            dependencies: ["LRStreakKit"]
        ),
    ]
)
