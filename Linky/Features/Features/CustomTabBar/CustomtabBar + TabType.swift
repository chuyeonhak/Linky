//
//  CustomtabBar + TabType.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

extension CustomTabBar {
    enum TabType: Int, CaseIterable {
        case timeline = 0
        case tag = 1
        case more = 2
        case link = 3
        
        var title: String {
            switch self {
            case .timeline: return "타임라인"
            case .tag: return "태그"
            case .more: return "더보기"
            case .link: return "링크"
            }
        }
        
        private var imageName: String {
            switch self {
            case .timeline: return "icoTimeline"
            case .tag: return "icoTag"
            case .more: return "icoMore"
            case .link: return "icoLink"
            }
        }
        
        var onImage: UIImage? {
            UIImage(named: imageName + "On")
        }
        
        var offImage: UIImage? {
            UIImage(named: imageName + "Off")
        }
        
        var emptyImage: UIImage? {
            UIImage(named: imageName + "Empty")
        }
        
        var emptyText: String {
            switch self {
            case .timeline: return "내가 추가한 링크를\n시간 순서대로 볼 수 있어요."
            case .tag: return "내가 추가한 링크를\n태그 별로 볼 수 있어요"
            case .more: return ""
            case .link: return "링크 등록 완료!"
            }
        }
        
        var addLinkTitle: String {
            return "링크 추가하기"
        }
    }
}
