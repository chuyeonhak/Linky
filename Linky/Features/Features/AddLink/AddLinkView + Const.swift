//
//  AddLinkView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

import Core

public extension AddLinkView {
    struct Const {
        enum Custom {
            case title
            case placeholder
            case text
            case buttonTitle
            case buttonBG
            
            var color: UIColor? {
                switch self {
                case .title, .text: return .code2
                case .placeholder: return .code4
                case .buttonTitle: return .naviCode1
                case .buttonBG: return .naviCode3
                }
            }
        }
        
        enum Text {
            static let addLinkTitle = I18N.addLink
            static let placeholder = I18N.addLinkPlaceholder
            static let pasteButtonTitle = I18N.pasteButtonText
        }
    }
}
