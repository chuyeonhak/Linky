//
//  MetaData.swift
//  Core
//
//  Created by chuchu on 2023/06/29.
//

import Foundation
import CloudKit

public struct MetaData: Codable {
    public let url: String?
    public let title: String?
    public let subtitle: String?
    public let imageData: Data?
    
    public static func createInstance(from record: CKRecord) async throws -> MetaData? {
        var contentData: MetaData?
        
        if let contentReference = record["content"] as? CKRecord.Reference {
            let contentRecord = try await CloudKitManager().fetch(recordID: contentReference.recordID)
            contentData = MetaData(from: contentRecord)
        }
        
        return contentData
    }
    
    public init(url: String?) {
        self.url = url
        self.title = nil
        self.subtitle = nil
        self.imageData = nil
    }
    
    public init(url: String?, title: String?, subtitle: String? = nil, imageData: Data?) {
        self.url = url
        self.title = title
        self.subtitle = subtitle
        self.imageData = imageData
    }
    
    init?(from record: CKRecord?) {
        guard let record,
              let url = record["url"] as? String,
              let title = record["title"] as? String
        else { return nil }
        
        self.url = url
        self.title = title
        self.subtitle = record["subtitle"] as? String
        
        if let imageData = record["imageData"] as? Data {
            self.imageData = imageData
        } else {
            self.imageData = nil
        }
    }
}

extension MetaData: Equatable {
    public static func == (lhs: MetaData, rhs: MetaData) -> Bool {
        lhs.url == rhs.url
    }
}

extension MetaData {
    var record: CKRecord {
        let record = CKRecord(recordType: "MetaData", recordID: CKRecord.ID(recordName: url ?? ""))
        
        record["url"] = url as CKRecordValue?
        record["title"] = title as CKRecordValue?
        record["subtitle"] = subtitle as CKRecordValue?
        record["imageData"] = imageData as CKRecordValue?
        
//        if let imageData {
//            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
//            do {
//                try imageData.write(to: tempURL)
//                let asset = CKAsset(fileURL: tempURL)
//                record["imageData"] = asset
//            } catch {
//                print("Error writing image data to temp file: \(error)")
//            }
//        }
        
        return record
    }
}
