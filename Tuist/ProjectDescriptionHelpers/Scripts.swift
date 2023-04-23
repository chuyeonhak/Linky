//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription

public extension TargetScript {
    static let firebaseCrashString = TargetScript.pre(script: """
    if [ "${CONFIGURATION}" != "Debug" ]; then
         "Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run" "Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols" -gsp ./Resources/GoogleService-Info.plist -p ios ${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}
    fi
    """, name: "Firebase Crashlystics")
//    static let firebaseCrashScript = TargetScript
//        .pre(path: .relativeToManifest("./Scripts/FBCrashlyticsRunScript.sh"),
//             name: "Firebase Crashlystics")
}




