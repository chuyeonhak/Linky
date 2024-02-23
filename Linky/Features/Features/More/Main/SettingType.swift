//
//  SettingType.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

enum SettingType: CaseIterable {
    case notificationSettings
    case tips
    case lock
    case tagManagement
    case linkManagement
//    case synchronizationGuide
    case inquiry
    
    var title: String {
        switch self {
        case .notificationSettings: return I18N.notificationSettings
        case .tips: return I18N.tips
        case .lock: return I18N.lock
        case .tagManagement: return I18N.tagManagement
        case .linkManagement: return I18N.linkManagement
//        case .synchronizationGuide: return "동기화 안내"
        case .inquiry: return I18N.inquiry
        }
    }
    
    var image: UIImage? {
        return UIImage(named: imageName)
    }
    
    private var imageName: String {
        switch self {
        case .notificationSettings: return "icoNotification"
        case .tips: return "icoFire"
        case .lock: return "icoLock"
        case .tagManagement: return "icoTag"
        case .linkManagement: return "icoLink"
//        case .synchronizationGuide: return "icoGuid"
        case .inquiry: return "icoInquiry"
        }
    }
}
