// swift-tools-version:6.1

import PackageDescription

let package = Package(
	name: "GitLabAPI",
	platforms: [
		.iOS(.v15),
		.macOS(.v12),
		.tvOS(.v15),
		.watchOS(.v8),
		.visionOS(.v1),
	],
	products: [
		.library(name: "GitLabAPI", targets: ["GitLabAPI"])
	],
	dependencies: [
		.package(url: "https://github.com/felix-schindler/apollo-skip-fuse", exact: "2.4.2")
	],
	targets: [
		.target(
			name: "GitLabAPI",
			dependencies: [
				.product(name: "ApolloAPI", package: "apollo-skip-fuse")
			],
			path: "./Sources"
		)
	],
	swiftLanguageModes: [.v6, .v5]
)
