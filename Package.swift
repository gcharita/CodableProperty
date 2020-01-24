// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "CodableProperty",
    platforms: [
        .watchOS(.v2),
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
    ],
    products: [
        .library(name: "CodableProperty", targets: ["CodableProperty"]),
    ],
    targets: [
        .target(name: "CodableProperty", path: "./CodableProperty/Classes")
    ],
    swiftLanguageVersions: [.v5]
)
