//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by chuchu on 4/2/24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
