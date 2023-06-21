//
//  Tag.swift
//  Core
//
//  Created by chuchu on 2023/06/14.
//

import Foundation

public struct TagData: Codable {
    public let tagNo: Int
    public var title: String
    public let creationDate: Date
    
    public init(title: String, creationDate: Date) {
        self.tagNo = TagData.getNextTagNo()
        self.title = title
        self.creationDate = creationDate
    }
    
    public static func getNextTagNo() -> Int {
        guard let tagNo = UserDefaultsManager.shared.tagList.last?.tagNo else { return 0 } 
        
        return tagNo + 1
    }
}

extension TagData: Equatable { }
