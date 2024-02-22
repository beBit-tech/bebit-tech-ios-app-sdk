// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "OmniSegmentKit",
	platforms: [
		.iOS(.v15)
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
			url: "https://github.com/beBit-tech/bebit-tech-ios-app-sdk/releases/download/0.0.3/OmniSegmentKit.xcframework.zip",
			checksum: "5e8f7525308934b4f394ae6a33df14021b7765cea96ba4ba093f1173969de09a"
		)
	]
)
