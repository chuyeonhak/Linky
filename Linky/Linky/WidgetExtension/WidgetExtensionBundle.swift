//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by chuchu on 4/2/24.
//  Copyright © 2024 com.chuchu. All rights reserved.
//

import WidgetKit
import SwiftUI

@available(iOSApplicationExtension 15.0, *)
@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
    }
}
