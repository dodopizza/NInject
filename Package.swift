// swift-tools-version:5.5

import PackageDescription

// swiftformat:disable all
let package = Package(
    name: "NInject",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "NInject", targets: ["NInject"]),
        .library(name: "NInjectTestHelpers", targets: ["NInjectTestHelpers"])
    ],
    dependencies: [
        .package(url: "git@github.com:NikSativa/NSpry.git", .upToNextMajor(from: "1.1.2")),
        .package(url: "https://github.com/Quick/Quick.git", .upToNextMajor(from: "4.0.0")),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "9.0.0"))
    ],
    targets: [
        .target(name: "NInject",
                dependencies: [],
                path: "Source"),
        .target(name: "NInjectTestHelpers",
                dependencies: ["NInject",
                               "NSpry"],
                path: "TestHelpers"),
        .testTarget(name: "NInjectTests",
                    dependencies: ["NInject",
                                   "NInjectTestHelpers",
                                   "NSpry",
                                   .product(name: "NSpry_Nimble", package: "NSpry"),
                                   "Nimble",
                                   "Quick"],
                    path: "Tests",
                    exclude: ["Resources/cocoapods"])
    ],
    swiftLanguageVersions: [.v5]
)
