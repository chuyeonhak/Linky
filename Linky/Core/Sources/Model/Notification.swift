//
//  Notification.swift
//  Core
//
//  Created by chuchu on 2023/07/18.
//

import Foundation


public struct NotificationInfo: Codable {
    public let days: Days
    public var selected: Bool
}

extension NotificationInfo: Equatable { }

public struct NotificationSetting: Codable {
    public var info: [NotificationInfo]
    public var time: Date?
}

extension NotificationSetting: Equatable { }

public enum Days: Int {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    public var korean: String {
        switch self {
        case .sun:
            return "일요일"
        case .mon:
            return "월요일"
        case .tue:
            return "화요일"
        case .wed:
            return "수요일"
        case .thu:
            return "목요일"
        case .fri:
            return "금요일"
        case .sat:
            return "토요일"
        }
    }
}

extension Days: CaseIterable, Codable { }
