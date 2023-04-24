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
            base: .init().automaticCodeSigning(devTeam: "GP9D94CZ57")
                .merging(
                    ["OTHER_LDFLAGS" : "-ObjC",
                     "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"]),
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
            scripts: [.firebaseCrashString],
            dependencies: dependencies
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
        
        let schemes: [Scheme] = [.makeScheme(target: .debug, name: name)]
        
        let targets: [Target] = [appTarget, testTarget]
        
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
            targets: Features.allCases.map(\.target),
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
