//
//  Project + Feature.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/24.
//

import ProjectDescription

public enum Features {
    case features
    case home
    case module
}

public extension Features {
    var isUsing: Bool {
        switch self {
        case .features: return true
        case .home: return true
        case .module: return true
        }
    }
    
    var name: String {
        switch self {
        case .features:
            return "Features"
        case .home:
            return "Home"
        case .module:
            return "Module"
        }
    }
    
    var bundleId: String {
        return Project.Linky.bundleId + "features"
    }
    
    var target: Target {
        return Target(
            name: name,
            platform: .iOS,
            product: .staticFramework,
            bundleId: bundleId,
            deploymentTarget: Project.Linky.deploymentTarget,
            infoPlist: Project.Linky.infoPlist,
            sources: ["\(name)/**"],
            dependencies: []
        )
    }
}

extension Features: CaseIterable {}
