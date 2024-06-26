//
//  Project.swift
//  LinkyManifests
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeAppProject(
    name: Module.app.name,
    platform: .iOS,
    product: .app,
    dependencies: [
        TargetDependency.SPM.firebaseCrashlytics,
        TargetDependency.SPM.firebaseRemoteConfig,
        TargetDependency.SPM.swinject,
        TargetDependency.SPM.rxSwift,
        TargetDependency.SPM.rxCocoa,
        Module.core.project,
        Module.features.project
    ],
    resources: ["Resources/**", "PrivacyInfo.xcprivacy"],
    infoPlist: Project.Linky.infoPlist)

