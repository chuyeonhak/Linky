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
            return UIImage(named: imageName + "On")
        }
        
        var offImage: UIImage? {
            return UIImage(named: imageName + "Off")
        }
    }
}
