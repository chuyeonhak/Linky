//
//  UserDefaultManager.swift
//  Core
//
//  Created by chuchu on 2023/06/12.
//

import Foundation

public struct UserDefaultsManager {
    public enum Key {
        fileprivate static let usePassword = "usePassword"
        fileprivate static let password = "password"
        fileprivate static let useBiometricsAuth = "useBiometricsAuth"
        fileprivate static let isFirstBioAuth = "isFirstBioAuth"
        fileprivate static let tagList = "tagList"
        fileprivate static let dropedTagList = "dropedTagList"
        public static let linkList = "linkList"
        public static let isAllowedNotification = "isAllowedNotification"
        fileprivate static let useNotification = "useNotification"
        fileprivate static let notiSetting = "notiSetting"
        fileprivate static let sharedMetaData = "sharedMetaData"
        fileprivate static let inquiryDic = "inquiryCount"
        fileprivate static let isFirstEndingCredit = "isFirstEndingCredit"
        fileprivate static let notice = "notice"
        fileprivate static let errorURL = "errorURL"
        fileprivate static let wantURL = "wantURL"
        fileprivate static let etcURL = "etcURL"
    }
    
    public static var shared = UserDefaultsManager()
    
    public let userDefaults = UserDefaults(suiteName: "group.com.chuchu.Linky")
    
    public var usePassword: Bool {
        get {
            guard let usePassword = userDefaults?.value(forKey: Key.usePassword) as? Bool
            else { return false }
            
            return usePassword
        }
        set {
            userDefaults?.set(newValue, forKey: Key.usePassword)
        }
    }
    
    public var password: String {
        get {
            guard let password = userDefaults?.value(forKey: Key.password) as? String
            else { return "" }
            
            return password
        }
        set {
            userDefaults?.set(newValue, forKey: Key.password)
        }
    }
    
    public var useBiometricsAuth: Bool {
        get {
            guard let useBiometricsAuth = userDefaults?
                .value(forKey: Key.useBiometricsAuth) as? Bool
            else { return false }
            
            return useBiometricsAuth
        }
        set {
            userDefaults?.set(newValue, forKey: Key.useBiometricsAuth)
        }
    }
    
    public var isFirstBioAuth: Bool {
        get {
            guard let isFirstBioAuth = UserDefaults
                .standard
                .value(forKey: Key.isFirstBioAuth) as? Bool
            else { return false }
            
            return isFirstBioAuth
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isFirstBioAuth)
        }
    }
    
    public var tagList: [TagData] {
        get {
            guard let tagListData = userDefaults?.value(forKey: Key.tagList) as? Data,
                  case let decoder = JSONDecoder(),
                  let tagList = try? decoder.decode([TagData].self, from: tagListData)
            else { return  [] }
            
            return tagList
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            userDefaults?.setValue(encoded, forKey: Key.tagList)
        }
    }
    
    public var linkList: [Link] {
        get {
            guard let linkListData = userDefaults?.value(forKey: Key.linkList) as? Data,
                  case let decoder = JSONDecoder(),
                  let linkList = try? decoder.decode([Link].self, from: linkListData)
            else { return  [] }
            
            return linkList
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            userDefaults?.setValue(encoded, forKey: Key.linkList)
        }
    }
    
    public var isAllowedNotification: Bool {
        get {
            guard let isAllowedNotification = UserDefaults
                .standard
                .value(forKey: Key.isAllowedNotification) as? Bool
            else { return false }
            
            return isAllowedNotification
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.isAllowedNotification)
        }
    }
    
    public var useNotification: Bool {
        get {
            guard let useNotification = UserDefaults
                .standard
                .value(forKey: Key.useNotification) as? Bool
            else { return false }
            
            return useNotification
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.useNotification)
        }
    }
    
    public var notiSetting: NotificationSetting {
        get {
            guard let notiSetting = UserDefaults.standard.value(forKey: Key.notiSetting) as? Data,
                  case let decoder = JSONDecoder(),
                  let noti = try? decoder.decode(NotificationSetting.self, from: notiSetting)
            else { return  getDefaultNotificationSetting() }
            
            return noti
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Key.notiSetting)
        }
    }
    
    public var limitInquiryDic: [Int: Int] {
        get {
            guard let inquiryData = UserDefaults.standard.value(forKey: Key.inquiryDic) as? Data,
                  case let decoder = JSONDecoder(),
                  let inquiryDic = try? decoder.decode([Int: Int].self, from: inquiryData)
            else { return [:] }
            
            return inquiryDic
        }
        
        set {
            guard case let encoder = JSONEncoder(),
                  let encoded = try? encoder.encode(newValue)
            else { return }
            
            UserDefaults.standard.setValue(encoded, forKey: Key.inquiryDic)
        }
    }
    
    public var isFirstEndingCredit: Bool {
        get {
            guard let isFirstEndingCredit = userDefaults?
                .value(forKey: Key.isFirstEndingCredit) as? Bool
            else { return true }
            
            return isFirstEndingCredit
        }
        set {
            userDefaults?.set(newValue, forKey: Key.isFirstEndingCredit)
        }
    }
    
    public var notice: String {
        get {
            guard let notice = userDefaults?
                .value(forKey: Key.notice) as? String
            else { return "" }
            
            return notice
        }
        set {
            userDefaults?.set(newValue, forKey: Key.notice)
        }
    }
    
    public var errorURL: String {
        get {
            guard let errorURL = userDefaults?.value(forKey: Key.errorURL) as? String
            else { return "" }
            
            return errorURL
        }
        set {
            userDefaults?.set(newValue, forKey: Key.errorURL)
        }
    }
    
    public var wantURL: String {
        get {
            guard let wantURL = userDefaults?.value(forKey: Key.wantURL) as? String
            else { return "" }
            
            return wantURL
        }
        set {
            userDefaults?.set(newValue, forKey: Key.wantURL)
        }
    }
    
    public var etcURL: String {
        get {
            guard let etcURL = userDefaults?.value(forKey: Key.etcURL) as? String
            else { return "" }
            
            return etcURL
        }
        set { userDefaults?.set(newValue, forKey: Key.etcURL) }
    }
    
    
    
    public var noTagData: [TagData] {
        noTagLinkList.isEmpty ? []: [TagData(title: I18N.noTags, createdAt: Date())]
    }
    
    public var noTagLinkList: [Link] { linkList.filter(\.hasNoTagList) }
    
    public var sortedLinksByDate: [(key: String, values: [Link])] {
        let unRemovedLinkList = linkList.filter { !$0.isRemoved }
        
        return categorizeLinksByDateRanges(links: unRemovedLinkList)
    }
    
    func categorizeLinksByDateRanges(links: [Link]) -> [(key: String, values: [Link])] {
        var copyLinks = links
        let calendar = Calendar.current
        let now = Date()
        
        var categorizedLinks: [(key: String, values: [Link])] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        let todayLinks = copyLinks.filter { calendar.isDateInToday($0.createdAt) }
        if !todayLinks.isEmpty {
            categorizedLinks.append((I18N.today, todayLinks))
        }
        
        let yesterdayLinks = copyLinks.filter { calendar.isDateInYesterday($0.createdAt) }
        if !yesterdayLinks.isEmpty { categorizedLinks.append((I18N.yesterday, yesterdayLinks)) }
        
        if let threeDaysAgo = calendar.date(byAdding: .day, value: -2, to: now),
           let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now),
           case let recentLinks = copyLinks.filter({ $0.createdAt > sevenDaysAgo && $0.createdAt <= threeDaysAgo }),
            !recentLinks.isEmpty { categorizedLinks.append((I18N.previous7Day, recentLinks)) }
        
        if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now),
           let eightDaysAgo = calendar.date(byAdding: .day, value: -8, to: now),
           case let olderLinks = copyLinks.filter({ $0.createdAt > thirtyDaysAgo && $0.createdAt <= eightDaysAgo }),
        !olderLinks.isEmpty { categorizedLinks.append((I18N.previous30Day, olderLinks)) }
        
        if let thirtyDaysAgo = calendar.date(byAdding: .day, value: -30, to: now),
           case let monthLinks = copyLinks.filter({ $0.createdAt > thirtyDaysAgo && $0.createdAt <= now }),
           !monthLinks.isEmpty { copyLinks.removeAll { monthLinks.contains($0) } }
        
        
        let thisYear = calendar.component(.year, from: now)
        
        let thisYearLink = copyLinks.filter { calendar.component(.year, from: $0.createdAt) == thisYear }
        let anotherYearLink = copyLinks.filter { calendar.component(.year, from: $0.createdAt) != thisYear }
        
        let thisYearCategoryList: [String: [Link]] = thisYearLink.reduce(into: [:]) { result, link in
            let key = dateFormatter.string(from: link.createdAt)
            result[key, default: []].append(link)
        }
        
        let anotherYearCategoryList: [String: [Link]] = anotherYearLink.reduce(into: [:]) { result, link in
            let key = String(calendar.component(.year, from: link.createdAt)) + I18N.year
            result[key, default: []].append(link)
        }
        
        categorizedLinks.append(contentsOf: thisYearCategoryList.sorted { $0.key > $1.key }.map { (key: $0.key, values: $0.value) })
        categorizedLinks.append(contentsOf: anotherYearCategoryList.sorted { $0.key > $1.key }.map { (key: $0.key, values: $0.value) })
        
        return categorizedLinks
    }
}
