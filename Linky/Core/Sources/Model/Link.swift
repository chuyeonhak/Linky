//
//  Link.swift
//  Core
//
//  Created by chuchu on 2023/06/21.
//

import Foundation

public struct Link: Codable {
    public let no: Int
    public var url: String?
    public let creationDate: Date
    public var isRemoved: Bool
    public var content: MetaData?
    public var tagList: [TagData] = [TagData(title: "태그 없음", creationDate: Date())]
    public var linkMemo: String = ""
    
    public init(url: String?) {
        self.no = Link.getNextNo()
        self.url = url
        self.creationDate = Date()
        self.isRemoved = true
        self.content = nil
    }
    
    private static func getNextNo() -> Int {
        guard let tagNo = UserDefaultsManager.shared.linkList.last?.no else { return 0 }
        
        return tagNo + 1
    }
    
    public var dateText: String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy.MM.dd HH:MM"
        formatter.locale = Locale(identifier: "ko_KR")
        
        return formatter.string(from: creationDate)
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
