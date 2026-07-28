// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "SwiftWebGPU",
    platforms: [.macOS(.v13)],  // Required for JavaScriptKit dependency, ignored when building for WASM
    products: [
        .library(
            name: "SwiftWebGPU",
            targets: ["SwiftWebGPU"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", exact: "0.56.1"),
    ],
    targets: [
        .target(
            name: "SwiftWebGPU",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
                .product(name: "JavaScriptEventLoop", package: "JavaScriptKit"),
            ]
        ),
        .testTarget(
            name: "SwiftWebGPUTests",
            dependencies: ["SwiftWebGPU"]
        ),
    ]
)
