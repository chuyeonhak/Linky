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
            case text
            case select
            case deselect
            
            var color: UIColor? {
                switch self {
                case .text: return .code3
                case .select: return .alphaCode3
                case .deselect: return .alphaCode2
                }
            }
        }
    }
}
