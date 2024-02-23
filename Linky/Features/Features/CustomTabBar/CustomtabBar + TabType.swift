//
//  CustomtabBar + TabType.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

extension CustomTabBar {
    enum TabType: Int, CaseIterable {
        case timeline = 0
        case tag = 1
        case more = 2
        case link = 3
        
        var title: String {
            switch self {
            case .timeline: return I18N.timeline
            case .tag: return I18N.tag
            case .more: return I18N.more
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
            case .timeline: return I18N.timeEmptyText
            case .tag: return I18N.timeEmptyText
            case .more: return ""
            case .link: return I18N.addLinkComplete
            }
        }
        
        var addLinkTitle: String {
            return I18N.addLink
        }
    }
}
