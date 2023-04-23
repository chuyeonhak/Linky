import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: [
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .exact("6.5.0")),
        .remote(
            url: "https://github.com/SnapKit/SnapKit.git",
            requirement: .upToNextMajor(from: "5.0.1")),
        .remote(
            url: "https://github.com/devxoul/Then",
            requirement: .upToNextMajor(from: "2")),
        .remote(
            url: "https://github.com/Swinject/Swinject.git",
            requirement: .exact("2.8.0")),
        .remote(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            requirement: .upToNextMajor(from: "10.4.0"))
    ],
    platforms: [.iOS]
)
