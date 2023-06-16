//
//  Tag.swift
//  Core
//
//  Created by chuchu on 2023/06/14.
//

import Foundation

public struct TagData: Codable {
    public let tagNo: Int
    public let title: String
    public let creationDate: Date
    
    public init(tagNo: Int, title: String, creationDate: Date) {
        self.tagNo = tagNo
        self.title = title
        self.creationDate = creationDate
    }
}
