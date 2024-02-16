//
//  SettingType.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit
//
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
        case .notificationSettings: return "알림설정"
        case .tips: return "링키 120% 활용하기"
        case .lock: return "화면 잠금 설정"
        case .tagManagement: return "태그 관리"
        case .linkManagement: return "링크 휴지통"
//        case .synchronizationGuide: return "동기화 안내"
        case .inquiry: return "문의하기"
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
