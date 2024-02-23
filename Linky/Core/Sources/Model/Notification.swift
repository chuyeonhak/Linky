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
    
    public var text: String {
        switch self {
        case .sun: return I18N.sunday
        case .mon: return I18N.monday
        case .tue: return I18N.tuesday
        case .wed: return I18N.wednesday
        case .thu: return I18N.thursday
        case .fri: return I18N.friday
        case .sat: return I18N.saturday
        }
    }
}

extension Days: CaseIterable, Codable { }
