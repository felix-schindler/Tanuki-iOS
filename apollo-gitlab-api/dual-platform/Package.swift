// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
    name: "gitlab-api",
    defaultLocalization: "en",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "GitLabAPI", type: .dynamic, targets: ["GitLabAPI"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.8.13"),
        .package(url: "https://source.skip.tools/skip-fuse.git", from: "1.0.0"),
		.package(path: "../ios")
    ],
    targets: [
        .target(name: "GitLabAPI", dependencies: [
            .product(name: "SkipFuse", package: "skip-fuse"),
			.product(name: "IOSGitLabAPI", package: "ios")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
