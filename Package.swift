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
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/1.1.0-beta.0/OmniSegmentKit.xcframework.zip",
			checksum: "5838fd065ca99f34bb476a6c3dc43387a26329db688ec6de39eedfced4d47ffa"
		)
	]
)
