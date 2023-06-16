//
//  UserDefaultManager.swift
//  Core
//
//  Created by chuchu on 2023/06/12.
//

import Foundation

public struct UserDefaultsManager {
    private enum Key {
        static let usePassword = "usePassword"
        static let password = "password"
        static let useBiometricsAuth = "useBiometricsAuth"
        static let isFirstBioAuth = "isFirstBioAuth"
        static let tagList = "tagList"
        static let dropedTagList = "dropedTagList"
    }
    public static var shared = UserDefaultsManager()
    
    public var usePassword: Bool {
        get {
            guard let usePassword = UserDefaults
                .standard
                .value(forKey: Key.usePassword) as? Bool
            else { return false }
            
            return usePassword
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.usePassword)
        }
    }
    
    public var password: String {
        get {
            guard let password = UserDefaults
                .standard
                .value(forKey: Key.password) as? String
            else { return "" }
            
            return password
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.password)
        }
    }
    
    public var useBiometricsAuth: Bool {
        get {
            guard let useBiometricsAuth = UserDefaults
                .standard
                .value(forKey: Key.useBiometricsAuth) as? Bool
            else { return false }
            
            return useBiometricsAuth
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.useBiometricsAuth)
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
            guard let tagListData = UserDefaults.standard.value(forKey: Key.tagList) as? Data,
                  case let decoder = JSONDecoder(),
                  let tagList = try? decoder.decode([TagData].self, from: tagListData)
            else { return  [] }
            
            return tagList
        }
    }
}
