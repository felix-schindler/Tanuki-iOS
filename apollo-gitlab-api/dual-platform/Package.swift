// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "gitlab-api",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v14), .watchOS(.v9)],
    products: [
        .library(name: "GitLabAPI", type: .dynamic, targets: ["GitLabAPI"])
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.8.13"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
        .package(url: "https://source.skip.dev/skip-kit.git", from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.11.0"),
    ],
    targets: [
        .target(
            name: "GitLabAPI",
            dependencies: [
                .product(name: "SkipFuse", package: "skip-fuse"),
                .product(name: "SkipKit", package: "skip-kit"),
                .product(name: "Alamofire", package: "Alamofire"),
            ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")])
    ]
)
