//
//  TagCell + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

extension TagCell {
    struct Const {
        enum Custom {
            case selectText
            case deselectText
            case select
            case deselect
            
            var color: UIColor? {
                switch self {
                case .selectText: return .code7
                case .deselectText: return .code3
                case .select: return .code3
                case .deselect: return .alphaCode2
                }
            }
        }
    }
}
