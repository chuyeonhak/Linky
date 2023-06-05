//
//  CustomTabBar + Const.swift
//  Features
//
//  Created by chuchu on 2023/05/04.
//

import UIKit

extension CustomTabBar {
    struct Const {
        enum Custom {
            case selected
            case deseleted
            
            var color: UIColor? {
                switch self {
                case .selected: return .code2
                case .deseleted: return .code4
                }
            }
        }
    }
}


