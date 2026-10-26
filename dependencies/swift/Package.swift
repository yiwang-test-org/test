// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DepGraphFixture",
    platforms: [.macOS(.v13)],
    products: [
        .library(name: "DepGraphFixture", targets: ["DepGraphFixture"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.76.0"),
    ],
    targets: [
        .target(
            name: "DepGraphFixture",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
            ]
        ),
    ]
)
