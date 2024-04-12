//
//  Project + App.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/20.
//

import ProjectDescription

extension Project {
    public enum Linky {
        public static let build: String = "0"
        public static let version: String = "1.0.6"
        public static let platform: Platform = .iOS
        public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad])
        public static let team = "6QDV2VZHAS"
        public static let name = "Linky"
        public static let bundleId = "com.chuchu"
        public static let infoPlist: ProjectDescription.InfoPlist = .file(path: "Support/Info.plist")
    }
    
    public enum Setting {
        public static let shareExtension: TargetDependency = .target(name: "ShareExtension")
        public static let widgetExtension: TargetDependency = .target(name: "WidgetExtension")
        
        static let baseSetting = SettingsDictionary()
            .automaticCodeSigning(devTeam: Linky.team)
            .merging(
                ["MARKETING_VERSION": .string(Linky.version) ,
                 "CURRENT_PROJECT_VERSION": .string(Linky.build),
                 "IPHONEOS_DEPLOYMENT_TARGET": "14.0",
                 "SWIFT_OBJC_BRIDGING_HEADER": "",
                 "SDKROOT" : "iphoneos",
                 "OTHER_LDFLAGS" : "-ObjC",
                 "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"]
            )
        
        static let configurations: [Configuration] = [
            .debug(name: .debug),
            .release(name: .release)]
        
        static let shareExtensionSetting: InfoPlist = .extendingDefault(with: [
            "NSExtensionAttributes": .dictionary([
                "NSExtensionActivationRule": .dictionary([
                    "NSExtensionActivationSupportsImageWithMaxCount": .integer(1),
                    "NSExtensionActivationSupportsWebURLWithMaxCount": .integer(1),
                    "NSExtensionActivationSupportsText": .boolean(true)
                ])
            ]),
            "NSExtensionPointIdentifier": .string("com.apple.share-services"),
            "NSExtensionPrincipalClass": .string("ShareExtension.ShareViewController"),
            "MARKETING_VERSION": .string(Linky.version),
            "CURRENT_PROJECT_VERSION": .string(Linky.build),
            "IPHONEOS_DEPLOYMENT_TARGET": "14.0",
        ])

    }
}
