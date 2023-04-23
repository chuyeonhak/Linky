//
//  Project.swift
//  LinkyManifests
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription
import ProjectDescriptionHelpers

//let project = Project.makeProject()

let project = Project.makeModule(
    name: "App",
    platform: .iOS,
    product: .app,
    dependencies: TargetDependency.spms,
    resources: ["Resources/**"],
    infoPlist: .file(path: "Support/Info.plist")
    )
