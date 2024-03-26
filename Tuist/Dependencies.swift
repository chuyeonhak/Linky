import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: SwiftPackageManagerDependencies([
        .remote(
            url: "https://github.com/ReactiveX/RxSwift.git",
            requirement: .exact("6.6.0")),
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
            requirement: .upToNextMajor(from: "10.4.0")),
        .remote(url: "https://github.com/Alamofire/Alamofire.git",
                requirement: .upToNextMajor(from: "5.6.4")),
        .remote(url: "https://github.com/scalessec/Toast-Swift.git",
                requirement: .upToNextMajor(from: "5.0.1")),
        .remote(url: "https://github.com/simibac/ConfettiSwiftUI",
                requirement: .upToNextMajor(from: "1.1.0"))
    ]),
    platforms: [.iOS]
)
