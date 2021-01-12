// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "chaqmoq-templating",
    products: [
        .library(name: "Templating", targets: ["Templating"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.23.0"),
        .package(name: "yaproq", url: "https://github.com/yaproq/yaproq.git", .branch("master"))
    ],
    targets: [
        .target(name: "Templating", dependencies: [
            .product(name: "Logging", package: "swift-log"),
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "Yaproq", package: "yaproq")
        ]),
        .testTarget(name: "TemplatingTests", dependencies: [
            .target(name: "Templating")
        ])
    ],
    swiftLanguageVersions: [.v5]
)
