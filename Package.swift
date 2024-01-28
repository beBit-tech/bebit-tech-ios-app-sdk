// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "beBit-Tech",
	platforms: [
		.iOS(.v15)
	],
	products: [
		.library(name: "beBit-Tech", targets: ["OmniSegmentTarget"]),
	],
	dependencies: [
		.package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMinor(from: "5.4.4")),
		.package(url: "https://github.com/ccgus/fmdb", .upToNextMinor(from: "2.7.7"))
	],
	targets: [
		.target(
			name: "OmniSegmentTarget",
			dependencies: [
				.target(name: "OmniSegmentKit"),
				.product(name: "Alamofire", package: "Alamofire"),
				.product(name: "FMDB", package: "FMDB")
			]
		),
		.binaryTarget(
			name: "OmniSegmentKit",
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/0.0.1/OmniSegmentKit.xcframework.zip",
			checksum: "00134afd7b27dd9df080945926e46dc53a0c75a56b23f6c9dff54b3ad620b32e"
		)
	]
)
