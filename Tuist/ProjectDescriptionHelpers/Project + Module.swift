//
//  Project + Module.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/24.
//

import ProjectDescription

public enum Module {
    case app
    case core
    case features
}

extension Module {
    public var name: String {
        switch self {
        case .app: return "App"
        case .core: return "Core"
        case .features: return "Features"
        }
    }
    
    public var path: ProjectDescription.Path {
        .relativeToRoot(Project.Linky.name + "/" + name)
      }

      public var project: TargetDependency {
        .project(target: name, path: path)
      }
}

extension Module: CaseIterable {}
