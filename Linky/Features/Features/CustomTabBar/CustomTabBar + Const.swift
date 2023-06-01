//
//  CustomTabBar + Const.swift
//  Features
//
//  Created by chuchu on 2023/05/04.
//

import UIKit

extension CustomTabBar {
    enum TabType: CaseIterable {
        case timeline
        case tag
        case more
        
        var title: String {
            switch self {
            case .timeline: return "타임라인"
            case .tag: return "태그"
            case .more: return "더보기"
            }
        }
        
        private var imageName: String {
            switch self {
            case .timeline: return "icoTimeline"
            case .tag: return "icoTag"
            case .more: return "icoMore"
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
            }
        }
        
        var addLinkTitle: String {
            return "링크 추가하기"
        }
    }
}

