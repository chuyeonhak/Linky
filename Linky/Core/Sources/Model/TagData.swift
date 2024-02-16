//
//  Tag.swift
//  Core
//
//  Created by chuchu on 2023/06/14.
//

import Foundation
import CloudKit

public struct TagData: Codable {
    public let tagNo: Int
    public var title: String
    public let createdAt: Date
    
    public init(title: String, createdAt: Date) {
        self.tagNo = TagData.getNextTagNo()
        self.title = title
        self.createdAt = createdAt
    }
    
    public static func getNextTagNo() -> Int {
        guard let tagNo = UserDefaultsManager.shared.tagList.last?.tagNo else { return 0 }
        
        return tagNo + 1
    }
    
    init?(from record: CKRecord) {
        guard let tagNo = record["tagNo"] as? Int,
              let title = record["title"] as? String,
              let createdAt = record["createdAt"] as? Date
        else { return nil }
        
        self.tagNo = tagNo
        self.title = title
        self.createdAt = createdAt
    }
}

extension TagData: Equatable {
    public static func == (lhs: TagData, rhs: TagData) -> Bool { lhs.title == rhs.title }
}

extension TagData: Hashable { }

extension TagData {
    var record: CKRecord {
        let record = CKRecord(recordType: "TagData")
        
        record["tagNo"] = tagNo as CKRecordValue
        record["title"] = title as CKRecordValue
        record["createdAt"] = createdAt as CKRecordValue
        
        return record
    }
}
