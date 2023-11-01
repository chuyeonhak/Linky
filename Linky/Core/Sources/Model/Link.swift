//
//  Link.swift
//  Core
//
//  Created by chuchu on 2023/06/21.
//

import Foundation
import CloudKit

public struct Link: Codable {
    public let no: Int
    public var url: String?
    public let createdAt: Date
    public var isRemoved: Bool
    public var isWrittenCount: Int
    public var content: MetaData?
    public var tagList: [TagData] = []
    public var linkMemo: String = ""
    
    internal init(no: Int,
                  url: String? = nil,
                  createdAt: Date,
                  isRemoved: Bool,
                  isWrittenCount: Int,
                  content: MetaData? = nil,
                  tagList: [TagData] = [],
                  linkMemo: String = "") {
        self.no = no
        self.url = url
        self.createdAt = createdAt
        self.isRemoved = isRemoved
        self.isWrittenCount = isWrittenCount
        self.content = content
        self.tagList = tagList
        self.linkMemo = linkMemo
    }
    
    
    public static func createInstance(from record: CKRecord) async throws -> Link? {
        guard let no = Int(record.recordID.recordName),
              let url = record["url"] as? String,
              let createdAt = record["createdAt"] as? Date,
              let isRemoved = record["isRemoved"] as? Bool,
              let isWrittenCount = record["isWrittenCount"] as? Int,
              let linkMemo = record["linkMemo"] as? String
        else { return nil }
        
        let contentData = try await MetaData.createInstance(from: record)
        
        return Link(no: no,
                    url: url,
                    createdAt: createdAt,
                    isRemoved: isRemoved,
                    isWrittenCount: isWrittenCount,
                    content: contentData,
                    tagList: [],
                    linkMemo: linkMemo)
    }

    
    public init(url: String?) {
        self.no = Link.getNextNo()
        self.url = url
        self.createdAt = Date()
        self.isRemoved = false
        self.isWrittenCount = 0
        self.content = nil
    }
    
    private static func getNextNo() -> Int {
        guard let tagNo = UserDefaultsManager.shared.linkList.last?.no else { return 0 }
        
        return tagNo + 1
    }
    
    public var dateToString: String {
        return createdAt.dateToString()
    }
    
    private func makeTagList(from records: [CKRecord]?) -> [TagData] {
        guard let records else { return [] }
        
        return records.compactMap { TagData(from: $0) }
    }
    
    public func linkToRecord() async throws -> CKRecord {
        let record = CKRecord(recordType: "Link", recordID: CKRecord.ID(recordName: "\(no)"))
        record["no"] = no as CKRecordValue
        record["url"] = url as CKRecordValue?
        record["createdAt"] = createdAt as CKRecordValue
        record["isRemoved"] = isRemoved as CKRecordValue
        record["isWrittenCount"] = isWrittenCount as CKRecordValue
        record["linkMemo"] = linkMemo as CKRecordValue
        
        if let content = content {
            let savedRecord = try await saveContentRecord(for: content)
            record["content"] = CKRecord.Reference(record: savedRecord, action: .none)
        }
        
        return record
    }
    
    private func saveContentRecord(for content: MetaData) async throws -> CKRecord {
        do {
            let savedRecord = try await CloudKitManager().save(record: content.record)
            return savedRecord
        } catch {
            print("Error saving content record: \(error)")
            throw error
        }
    }
}

extension Link: Equatable { }

public struct Content: Codable {
    public let title: String
    public let subtitle: String
    public let count: String
    public let image: String
    
    init(url: String?) {
        self.title = url ?? ""
        self.subtitle = ""
        self.count = ""
        self.image = ""
    }
}

extension Content: Equatable { }
