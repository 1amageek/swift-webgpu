// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SwiftWebGPU",
    platforms: [.macOS(.v10_15)],  // Required for JavaScriptKit dependency, ignored when building for WASM
    products: [
        .library(
            name: "SwiftWebGPU",
            targets: ["SwiftWebGPU"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftwasm/JavaScriptKit", from: "0.37.0"),
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
