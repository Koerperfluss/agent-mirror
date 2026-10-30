// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "LokiCanvas",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "LokiCanvasCore"),
        .executableTarget(
            name: "LokiCanvasApp",
            dependencies: ["LokiCanvasCore"],
            path: "Sources/LokiCanvasApp"
        ),
        .testTarget(
            name: "LokiCanvasCoreTests",
            dependencies: ["LokiCanvasCore"],
            path: "Tests/LokiCanvasCoreTests"
        )
    ]
)
