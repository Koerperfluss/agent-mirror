// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "TraktorClone",
    platforms: [.macOS(.v13)],
    targets: [
        .target(name: "TraktorCloneCore"),
        .executableTarget(
            name: "TraktorCloneApp",
            dependencies: ["TraktorCloneCore"],
            path: "Sources/TraktorCloneApp"
        ),
        .testTarget(
            name: "TraktorCloneCoreTests",
            dependencies: ["TraktorCloneCore"],
            path: "Tests/TraktorCloneCoreTests"
        )
    ]
)
