//
//  Dependency + SPM.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM: CaseIterable {
        static let rxSwift = TargetDependency.external(name: "RxSwift")
        static let rxCocoa = TargetDependency.external(name: "RxCocoa")
        static let rxRelay = TargetDependency.external(name: "RxRelay")
        static let snpaKit = TargetDependency.external(name: "SnapKit")
        static let then = TargetDependency.external(name: "Then")
        static let swinject = TargetDependency.external(name: "Swinject")
        static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
        static let firebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
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
