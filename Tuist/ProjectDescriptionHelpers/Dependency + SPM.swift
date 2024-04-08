//
//  Dependency + SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM: CaseIterable {
        public static let rxSwift = TargetDependency.external(name: "RxSwift")
        public static let rxCocoa = TargetDependency.external(name: "RxCocoa")
        public static let snapkit = TargetDependency.external(name: "SnapKit")
        public static let then = TargetDependency.external(name: "Then")
        public static let swinject = TargetDependency.external(name: "Swinject")
        public static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
        public static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
        public static let firebaseRemoteConfig = TargetDependency.external(name: "FirebaseRemoteConfig")
        public static let alamofire = TargetDependency.external(name: "Alamofire")
        public static let toast = TargetDependency.external(name: "Toast")
        public static let confetti = TargetDependency.external(name: "ConfettiSwiftUI")
        public static let marqueeText = TargetDependency.external(name: "MarqueeText")
    }
    
    static let spms: [TargetDependency] = [
        SPM.rxSwift,
        SPM.rxCocoa,
        SPM.snapkit,
        SPM.then,
        SPM.swinject,
        SPM.firebaseCrashlytics,
        SPM.firebaseRemoteConfig,
        SPM.confetti,
        SPM.marqueeText
    ]
}
