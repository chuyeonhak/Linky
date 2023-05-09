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
    
    static let SwiftLintString = TargetScript.pre(script: """
    if test -d "/opt/homebrew/bin/"; then
        PATH="/opt/homebrew/bin/:${PATH}"
    fi

    export PATH

    if which swiftlint > /dev/null; then
        swiftlint
    else
        echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
    fi
    """, name: "SwiftLintString")
}




