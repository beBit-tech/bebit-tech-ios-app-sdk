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
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/1.1.0-beta.1/OmniSegmentKit.xcframework.zip",
			checksum: "186ab688c28216495b92596e7c674ea90c13986f24459e088262a12dc11cd7eb"
		)
	]
)
