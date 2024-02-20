//
//  String +.swift
//  Core
//
//  Created by chuchu on 12/27/23.
//

import Foundation

public extension String {
    var localized: String { NSLocalizedString(self, comment: "") }
}
