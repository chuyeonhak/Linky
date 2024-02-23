//
//  LinkManageView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/21.
//

import UIKit

import Core

extension LinkManageView {
    struct Const {
        enum Custom {
            case title
            case emptyOff
            case emptyOn
            case recoveryOff
            case recoveryOn
            
            var color: UIColor? {
                switch self {
                case .title: return .code2
                case .emptyOff, .recoveryOff: return .code5
                case .emptyOn: return .error
                case .recoveryOn: return .main
                }
            }
        }
        
        enum Text {
            static let emptyButtonTitle = I18N.clear
            static let recoveryButtonTitle = I18N.recover
        }
    }
}
