//
//  AddLinkDetailView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/03.
//

import UIKit

import Core

extension AddLinkDetailView {
    struct Const {
        enum Custom {
            case subtitle
            case text
            case line
            case linkInfoBG
            case linkTitle
            case linkSubtitle
            case link
            
            var color: UIColor? {
                switch self {
                case .subtitle, .link: return .code3
                case .line: return .code6
                case .linkInfoBG: return .code7
                case .linkSubtitle: return .code4
                case .text: return .code2
                case .linkTitle: return .sub
                }
            }
        }
        
        enum Text {
            static let linkTitle = I18N.linkMemo
            static let addTagTitle = I18N.addTag
            static let linkPlaceholder = I18N.linkPlaceholder
            static let tagPlaceholder = I18N.tagPlaceholder
        }
    }
}
