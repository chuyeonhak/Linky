//
//  AddLinkView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

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
            static let addLinkTitle = "링크 추가하기"
            static let placeholder = "추가할 링크를 입력해주세요."
            static let pasteButtonTitle = "복사한 링크 붙여넣기"
        }
    }
}
