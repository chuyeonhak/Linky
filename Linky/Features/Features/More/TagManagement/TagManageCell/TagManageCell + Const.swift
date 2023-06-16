//
//  TagManageCell + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import UIKit

extension TagManageCell {
    struct Const {
        enum Custom {
            case checkBoxOn
            case checkBoxOff
            
            var image: UIImage? {
                switch self {
                case .checkBoxOn: return UIImage(named: "icoCheckBoxOn")
                case .checkBoxOff: return UIImage(named: "icoCheckBoxOff")
                }
            }
        }
    }
}
