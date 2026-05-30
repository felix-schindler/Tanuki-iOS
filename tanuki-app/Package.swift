// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
	name: "tanuki-app",
	defaultLocalization: "en",
	platforms: [.iOS(.v16), .macOS(.v14)],
	products: [
		.library(name: "Tanuki", type: .dynamic, targets: ["Tanuki"]),
	],
	dependencies: [
		.package(url: "https://source.skip.tools/skip.git", from: "1.8.6"),
		.package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
		.package(url: "https://source.skip.dev/skip-kit.git", from: "1.0.0"),
		.package(path: "../apollo-gitlab-api/dual-platform"),
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.11.0")),
	],
	targets: [
		.target(
			name: "Tanuki",
			dependencies: [
				.product(name: "SkipFuseUI", package: "skip-fuse-ui"),
				.product(name: "SkipKit", package: "skip-kit"),
				.product(name: "GitLabAPI", package: "dual-platform"),
				.product(name: "Alamofire", package: "Alamofire"),
			], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]
		),
	]
)
