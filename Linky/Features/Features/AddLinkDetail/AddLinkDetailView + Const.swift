//
//  AddLinkDetailView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/03.
//

import UIKit

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
            static let linkTitle = "링크 메모"
            static let addTagTitle = "태그 추가"
            static let linkPlaceholder = "ex.엄마가 공유해 줌"
            static let tagPlaceholder = "추가할 태그를 입력해 주세요."
        }
    }
}
