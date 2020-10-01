// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "NInject",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(name: "NInject", targets: ["NInject"]),
        .library(name: "NInjectTestHelpers", targets: ["NInjectTestHelpers"])
    ],
    dependencies: [
        .package(url: "https://github.com/NikSativa/Spry.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "3.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.1"))
    ],
    targets: [
        .target(name: "NInject",
                dependencies: [],
                path: "Source"),
        .target(name: "NInjectTestHelpers",
                dependencies: [
                    "NInject",
                    "Spry"
                ],
                path: "TestHelpers"),
        .testTarget(name: "NInjectTests",
                    dependencies: [
                        "NInject",
                        "NInjectTestHelpers",
                        "Spry",
                        .product(name: "Spry_Nimble", package: "Spry"),
                        "Nimble",
                        "Quick"
                    ],
                    path: "Tests/Specs",
                    exclude: ["Resources/cocoapods"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
