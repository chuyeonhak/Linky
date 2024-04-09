import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

public extension Project {
    static func makeAppProject(
        name: String,
        platform: Platform = .iOS,
        product: Product,
        organizationName: String = Linky.bundleId,
        packages: [Package] = [],
        deploymentTarget: DeploymentTarget? = Linky.deploymentTarget,
        dependencies: [TargetDependency] = [],
        sources: SourceFilesList = ["Sources/**"],
        resources: ResourceFileElements? = nil,
        infoPlist: InfoPlist = .default
    ) -> Project {
        let settings: Settings = .settings(
            base: Project.Setting.baseSetting,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ], defaultSettings: .recommended)
        
        let appTarget = Target(
            name: name,
            platform: platform,
            product: product,
            bundleId: "\(organizationName).\(name)",
            deploymentTarget: deploymentTarget,
            infoPlist: infoPlist,
            sources: sources,
            resources: resources,
            entitlements: "ShareExtension/LinkyDebug.entitlements",
            scripts: [.firebaseCrashString, .autoLocalization],
            dependencies: dependencies + [Project.Setting.shareExtension, Project.Setting.widgetExtension],
            settings: settings
        )
        
        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .unitTests,
            bundleId: "\(organizationName).\(name)Tests",
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [.target(name: name)]
        )
        
        let shareExtensionTarget = Target(
            name: "ShareExtension",
            platform: .iOS,
            product: .appExtension,
            bundleId: "\(organizationName).\(name).ShareExtension",
            deploymentTarget: deploymentTarget,
            infoPlist: .file(path: "ShareExtension/Info.plist"),
            sources: ["ShareExtension/**"],
            resources: resources,
            entitlements: "ShareExtension/ShareExtensionDebug.entitlements",
            dependencies: dependencies
        )
        
        let widgetExtensionTarget = Target(
            name: "WidgetExtension",
            platform: .iOS,
            product: .appExtension,
            bundleId: "\(organizationName).\(name).WidgetExtension",
            deploymentTarget: deploymentTarget,
            infoPlist: .file(path: "WidgetExtension/Info.plist"),
            sources: ["WidgetExtension/**"],
            resources: resources,
            entitlements: "WidgetExtension/WidgetExtension.entitlements",
            dependencies: dependencies
        )
        
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = [
            appTarget,
            testTarget,
            shareExtensionTarget,
            widgetExtensionTarget
        ]
        
        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: targets,
            schemes: schemes
        )
    }
    
    static func makeFrameworkProject(
        name: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> Project {
        let targtes = makeFrameworkTargets(
            name: name,
            bundleId: Linky.bundleId + ".\(name.lowercased())",
            dependencies: dependencies)
        
        return Project(
            name: name,
            targets: targtes,
            schemes: []
        )
    }
    
    private static func makeFrameworkTargets(
        name: String,
        bundleId: String,
        dependencies: [TargetDependency] = [],
        resources: ProjectDescription.ResourceFileElements? = nil
    ) -> [Target] {
        var targets: [Target] = []
        targets = [
            Target(
                name: "\(name)Interface",
                platform: .iOS,
                product: .staticFramework,
                bundleId: bundleId,
                deploymentTarget: Linky.deploymentTarget,
                infoPlist: Linky.infoPlist,
                sources: ["Interfaces/**"],
                resources: resources,
                dependencies: dependencies
            )
            ,Target(
                name: name,
                platform: .iOS,
                product: .staticFramework,
                bundleId: bundleId,
                deploymentTarget: Linky.deploymentTarget,
                infoPlist: Linky.infoPlist,
                sources: ["Sources/**"],
                resources: resources,
                dependencies: dependencies
            ),
            Target(
                name: "\(name)Tests",
                platform: .iOS,
                product: .unitTests,
                bundleId: bundleId,
                deploymentTarget: Linky.deploymentTarget,
                infoPlist: Linky.infoPlist,
                sources: "Tests/**",
                dependencies: [
                    .target(name: "\(name)"),
                    .target(name: "\(name)Interface")
                ],
                settings: .settings(base: SettingsDictionary()
                    .automaticCodeSigning(devTeam: Linky.team))
            )
        ]
        
        return targets
    }
    
    static func makeFeatureProject(
        name: String,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: name,
            packages: Features.allCases.filter(\.isUsing).map(\.package),
            targets: Features.allCases.filter(\.isUsing).map(\.target),
            schemes: []
        )
    }
    
}

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
