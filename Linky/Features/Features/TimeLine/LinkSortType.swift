//
//  File.swift
//  Features
//
//  Created by chuchu on 2023/07/11.
//

import Core

enum LinkSortType {
    case all
    case read
    case notRead
    
    var text: String {
        switch self {
        case .all: I18N.all
        case .read: I18N.read
        case .notRead: I18N.unread
        }
    }
}
