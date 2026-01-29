// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OmniSegmentKit",
	platforms: [
		.iOS(.v12)
	],
	products: [
		.library(name: "OmniSegmentKit", targets: ["OmniSegmentTarget"]),
	],
	dependencies: [],
	targets: [
		.target(
			name: "OmniSegmentTarget",
			dependencies: [
				.target(name: "OmniSegmentKit")
			]
		),
		.binaryTarget(
			name: "OmniSegmentKit",
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/1.0.12-beta.3/OmniSegmentKit.xcframework.zip",
			checksum: "fa31d5bdf5377d8ebdc39fb2bfadf93985c066776bb2fb46f7553409d41a03ee"
		)
	]
)
