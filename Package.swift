// swift-tools-version: 5.9
import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftLombok",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        .library(
            name: "SwiftLombok",
            targets: ["SwiftLombok"]
        ),
        .executable(
            name: "SwiftLombokClient",
            targets: ["SwiftLombokClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        .macro(
            name: "SwiftLombokMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(name: "SwiftLombok", dependencies: ["SwiftLombokMacros"]),
        .executableTarget(name: "SwiftLombokClient", dependencies: ["SwiftLombok"]),
        .testTarget(
            name: "SwiftLombokTests",
            dependencies: [
                "SwiftLombokMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
