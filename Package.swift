// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "POLocalizedString",
    products: [
        .library(
            name: "POLocalizedStringObjC",
            targets: ["muParser", "POLocalizedStringObjC"]),
        .library(
            name: "POLocalizedStringSwift",
            targets: ["muParser", "POLocalizedStringObjC", "POLocalizedStringSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "muParser",
            dependencies: [],
            path: "Sources/muParser"),
        .target(
            name: "POLocalizedStringObjC",
            dependencies: ["muParser"],
            path: "Sources/POLocalizedStringObjC"
        ),
        .target(
            name: "POLocalizedStringSwift",
            dependencies: ["POLocalizedStringObjC"],
            path: "Sources/POLocalizedStringSwift"
        )
    ]
)
