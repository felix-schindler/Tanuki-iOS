// swift-tools-version:6.1

import PackageDescription

let package = Package(
  name: "IOSGitLabAPI",
  platforms: [
    .iOS(.v15),
    .macOS(.v12),
    .tvOS(.v15),
    .watchOS(.v8),
    .visionOS(.v1),
  ],
  products: [
    .library(name: "IOSGitLabAPI", targets: ["IOSGitLabAPI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/felix-schindler/apollo-skip-fuse", from: "2.4.0"),
  ],
  targets: [
    .target(
      name: "IOSGitLabAPI",
      dependencies: [
        .product(name: "ApolloAPI", package: "apollo-skip-fuse"),
      ],
      path: "./Sources"
    ),
  ],
  swiftLanguageModes: [.v6, .v5]
)
