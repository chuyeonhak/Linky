//
//  UserDefaultsManager + Function.swift
//  Core
//
//  Created by chuchu on 2023/07/14.
//

import Foundation
import CloudKit

public extension UserDefaultsManager {
    func getTagDic() -> [TagData: [Link]] {
        var tempDic: [TagData: [Link]] = [:]
        let linkList = UserDefaultsManager.shared.linkList
        
        for link in linkList where !link.isRemoved {
            for tag in link.tagList {
                var linkArray = tempDic[tag] ?? []
                linkArray.append(link)
                tempDic[tag] = linkArray
            }
        }
        
        return tempDic
    }
    
    func deleteTagInLink(tag: TagData?) {
        guard let tag else { return }
        
        var copyLinkList = linkList
        
        for (index, link) in copyLinkList.enumerated() {
            var copyTagList = link.tagList
            
            if let firstIndex = copyTagList.firstIndex(of: tag),
               copyLinkList.indices ~= index {
                copyTagList.remove(at: firstIndex)
                copyLinkList[index].tagList = copyTagList
            }
        }
        
        UserDefaultsManager.shared.linkList = copyLinkList
    }
    
    func editTagInLink(tag: TagData?) {
        guard let tag else { return }
        
        var copyLinkList = linkList
        
        for (index, link) in copyLinkList.enumerated() {
            var copyTagList = link.tagList
            
            if let tagIndex = copyTagList.firstIndex(where: { $0.tagNo == tag.tagNo }) {
                copyTagList[tagIndex] = tag
                
                copyLinkList[index].tagList = copyTagList
            }
        }
        
        UserDefaultsManager.shared.linkList = copyLinkList
    }
    
    func getDefaultNotificationSetting() -> NotificationSetting {
        let info = Days.allCases.map { NotificationInfo(days: $0, selected: false) }
        
        return NotificationSetting(info: info, time: nil)
    }
}

extension CKRecord: @unchecked Sendable { }
