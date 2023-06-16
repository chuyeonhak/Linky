//
//  TagManageView + Const.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import Core

extension TagManageView {
    struct Const {
        
        enum Text {
            static let title = "\(UserDefaultsManager.shared.tagList.count)개의 태그가 있어요."
            static let subtitle = "연결된 링크가 있는 태그를 삭제하면 \n해당 링크는 '태그 없음'에 연결돼요."
            static let addTag = "태그 추가"
        }
    }
}
