// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-async-bridge",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Async Bridge", targets: ["Async Bridge"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-async.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-buffer.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-buffer-ring.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-column.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-deque.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-memory.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-memory-allocation.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-queue.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-storage-memory.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Async Bridge",
            dependencies: [
                .product(name: "Async Mutex", package: "swift-async"),
                .product(name: "Async Primitive", package: "swift-async"),
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Buffer Ring Primitive", package: "swift-buffer-ring"),
                .product(name: "Column", package: "swift-column"),
                .product(name: "Deque", package: "swift-deque"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Allocator", package: "swift-memory-allocation"),
                .product(name: "Queue", package: "swift-queue"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
            ],
            path: "Sources/Async Bridge"
        ),
        .testTarget(
            name: "Async Bridge Tests",
            dependencies: [
                .product(name: "Async", package: "swift-async"),
                .target(name: "Async Bridge"),
            ],
            path: "Tests/Async Bridge Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("RawLayout")
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
