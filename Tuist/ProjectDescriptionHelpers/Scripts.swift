//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by chuchu on 2023/04/21.
//

import ProjectDescription
import Foundation

public extension TargetScript {
    static let firebaseCrashString = TargetScript.post(
        script: """
    "../../Tuist/Dependencies/SwiftPackageManager/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
    """,
        name: "Firebase Crashlystics",
        inputPaths: [.glob("${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}"),
            .glob( "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)")],
        basedOnDependencyAnalysis: false)
    
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
    static let autoLocalization = TargetScript.pre(script: """
cd ../../
bash "Localizable.command"
#path=\(ProcessInfo.processInfo.environment["LINKYPATH"] ?? "")
#osascript -e 'tell app "System Events" to display dialog "'"${path}"'"'
"""
, name: "Localization")
}
