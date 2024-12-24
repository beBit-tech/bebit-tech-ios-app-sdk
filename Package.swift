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
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/1.0.3-beta.1/OmniSegmentKit.xcframework.zip",
			checksum: "37aeb8f9fa97525e256bce4d31c5daffabeadc426225b958d0b26aa1b54253cf"
		)
	]
)
