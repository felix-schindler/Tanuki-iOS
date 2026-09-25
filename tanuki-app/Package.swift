// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
	name: "tanuki-app",
	defaultLocalization: "en",
	platforms: [.iOS(.v17), .macOS(.v14)],
	products: [
		.library(name: "Tanuki", type: .dynamic, targets: ["Tanuki"])
	],
	dependencies: [
		.package(url: "https://source.skip.tools/skip.git", from: "1.9.11"),
		.package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.18.3"),
		.package(url: "https://source.skip.dev/skip-kit.git", from: "1.1.3"),
		.package(url: "https://github.com/felix-schindler/apollo-skip-fuse.git", from: "2.4.2"),
		.package(path: "../apollo-gitlab-api"),
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.12.2")),
		.package(url: "https://github.com/swiftlang/swift-cmark.git", revision: "0c8947bbd58c491c54aae114aca40621cddc8357"),
		.package(url: "https://github.com/skiptools/skip-web.git", from: "0.12.0"),
		.package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image.git", exact: "2.1.1"),
	],
	targets: [
		.target(
			name: "Tanuki",
			dependencies: [
				.product(name: "SkipFuseUI", package: "skip-fuse-ui"),
				.product(name: "SkipKit", package: "skip-kit"),
				.product(name: "Apollo", package: "apollo-skip-fuse"),
				.product(name: "ApolloAPI", package: "apollo-skip-fuse"),
				.product(name: "ApolloSQLite", package: "apollo-skip-fuse"),
				.product(name: "GitLabAPI", package: "apollo-gitlab-api"),
				.product(name: "Alamofire", package: "Alamofire"),
				.product(name: "cmark-gfm", package: "swift-cmark"),
				.product(name: "cmark-gfm-extensions", package: "swift-cmark"),
				.product(name: "SkipWeb", package: "skip-web"),
				.product(name: "CachedAsyncImage", package: "swiftui-cached-async-image", condition: .when(platforms: [.iOS, .macOS])),
			], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]
		)
	]
)
