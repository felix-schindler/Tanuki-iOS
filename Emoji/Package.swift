// swift-tools-version: 6.1
import PackageDescription

let package = Package(
	name: "TanukiEmoji",
	platforms: [.iOS(.v15), .watchOS(.v9)],
	products: [
		.library(name: "TanukiEmoji", targets: ["TanukiEmoji"])
	],
	targets: [
		.target(
			name: "TanukiEmoji",
			resources: [.process("Resources")]
		)
	]
)
