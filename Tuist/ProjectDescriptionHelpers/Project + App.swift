//
//  Project + App.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/20.
//

import ProjectDescription

extension Project {
    public enum Linky {
        public static let build: SettingValue = "1"
        public static let version: SettingValue = "1.0.1"
        public static let platform: Platform = .iOS
        public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "14.0", devices: [.iphone, .ipad])
        public static let team = "GP9D94CZ57"
        public static let name = "Linky"
        public static let bundleId = "com.linky.chu"
        public static let infoPlist: ProjectDescription.InfoPlist = .file(path: "Support/Info.plist")
        
    }
    
    public enum Setting {
        static let notificationService: TargetDependency = .target(name: "NotificationServiceExtension")
        static let widget: TargetDependency = .target(name: "WidgetExtension")
        static let baseSetting = SettingsDictionary()
            .automaticCodeSigning(devTeam: Linky.team)
            .merging(
                ["MARKETING_VERSION": Linky.version,
                 "CURRENT_PROJECT_VERSION": Linky.build,
                 "IPHONEOS_DEPLOYMENT_TARGET": "14.0",
                 "SWIFT_OBJC_BRIDGING_HEADER": "",
                 "SDKROOT" : "iphoneos",
                 "OTHER_LDFLAGS" : "-ObjC",
                 "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"]
            )
        
        static let configurations: [Configuration] = [
            .debug(name: .debug),
            .release(name: .release)]
    }
}
