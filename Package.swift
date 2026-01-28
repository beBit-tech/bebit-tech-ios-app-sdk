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
	dependencies: [
		.package(url: "https://github.com/Alamofire/Alamofire.git", "5.8.1"..<"6.0.0"),
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
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/1.0.11/OmniSegmentKit.xcframework.zip",
			checksum: "d2184abe683daeb2038d221b0baf7f769e3c3b65bcb4f9e79ff07a8098cfd337"
		)
	]
)
