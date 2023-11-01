//
//  OpenGraph.swift
//  Core
//
//  Created by chuchu on 2023/06/29.
//

import Foundation

public struct MetaData: Codable {
    public let url: String?
    public let title: String?
    public let subtitle: String?
    public let imageData: Data?
    
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
}

extension MetaData: Equatable {
    public static func == (lhs: MetaData, rhs: MetaData) -> Bool {
        lhs.url == rhs.url
    }
}
