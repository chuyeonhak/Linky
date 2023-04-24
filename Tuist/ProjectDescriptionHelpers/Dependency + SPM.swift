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
        public static let rxRelay = TargetDependency.external(name: "RxRelay")
        public static let snpaKit = TargetDependency.external(name: "SnapKit")
        public static let then = TargetDependency.external(name: "Then")
        public static let swinject = TargetDependency.external(name: "Swinject")
        public static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
        public static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
    }
    
    static let spms: [TargetDependency] = [
        SPM.rxSwift,
        SPM.rxCocoa,
        SPM.rxRelay,
        SPM.snpaKit,
        SPM.then,
        SPM.swinject,
        SPM.firebaseCrashlytics,
    ]
}
