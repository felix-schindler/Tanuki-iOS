// swift-tools-version: 6.1
// This is a Skip (https://skip.dev) package.
import PackageDescription

let package = Package(
	name: "tanuki-app",
	defaultLocalization: "en",
	platforms: [.iOS(.v17), .macOS(.v14)],
	products: [
		.library(name: "Tanuki", type: .dynamic, targets: ["Tanuki"]),
	],
	dependencies: [
		.package(url: "https://source.skip.tools/skip.git", from: "1.8.6"),
		.package(url: "https://source.skip.tools/skip-fuse-ui.git", from: "1.0.0"),
		.package(url: "https://source.skip.dev/skip-kit.git", from: "1.0.0"),
		.package(url: "https://github.com/apollographql/apollo-ios.git", from: "2.0.5"),
		.package(path: "../apollo-gitlab-api/dual-platform"),
		.package(path: "../apollo-gitlab-api/ios"),
		//.package(url: "https://github.com/kyle-n/HighlightedTextEditor.git", from: "2.1.0"),
		//.package(url: "https://github.com/raspu/Highlightr.git", from: "2.3.0"),
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.11.0")),
		//.package(url: "https://github.com/gonzalezreal/swift-markdown-ui.git", from: "2.4.1"),
		//.package(url: "https://github.com/BastiaanJansen/toast-swift.git", from: "2.1.3"),
		.package(url: "https://github.com/lorenzofiamingo/swiftui-cached-async-image.git", exact: "2.1.1"),
		//.package(url: "https://github.com/NVMNovem/nvm-color.git", from: "1.2.5")
	],
	targets: [
		.target(
			name: "Tanuki",
			dependencies: [
				.product(name: "SkipFuseUI", package: "skip-fuse-ui"),
				.product(name: "SkipKit", package: "skip-kit"),
				.product(name: "Apollo", package: "apollo-ios"),
				.product(name: "ApolloAPI", package: "apollo-ios"),
				.product(name: "ApolloSQLite", package: "apollo-ios"),
				.product(name: "GitLabAPI", package: "dual-platform"),
				//.product(name: "HighlightedTextEditor", package: "HighlightedTextEditor"),
				//.product(name: "Highlightr", package: "Highlightr"),
				.product(name: "Alamofire", package: "Alamofire"),
				//.product(name: "MarkdownUI", package: "swift-markdown-ui"),
				//.product(name: "CachedAsyncImage", package: "swiftui-cached-async-image"),
				//.product(name: "Toast", package: "toast-swift"),
				//.product(name: "NVMColor", package: "nvm-color")
			], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]
		),
	]
)
