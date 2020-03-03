// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "PIXLang",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "PIXLang",
            targets: ["PIXLang"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/Expression.git", .upToNextMinor(from: "0.12.0")),
//        .package(url: "https://github.com/hexagons/LiveValues.git", from: "1.1.7"),
//        .package(url: "https://github.com/hexagons/RenderKit.git", from: "0.3.3"),
//        .package(url: "https://github.com/hexagons/PixelKit.git", from: "0.9.5"),
        .package(path: "~/Code/Frameworks/Production/LiveValues"),
        .package(path: "~/Code/Frameworks/Production/RenderKit"),
        .package(path: "~/Code/Frameworks/Production/PixelKit"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PIXLang",
            dependencies: [
                "LiveValues",
                "RenderKit",
                "PixelKit",
                "Expression"
            ]),
        .testTarget(
            name: "PIXLangTests",
            dependencies: ["PIXLang"]),
    ]
)
