//
//  OpenGraph.swift
//  Core
//
//  Created by chuchu on 2023/06/29.
//

import OpenGraph

public struct MetaData: Codable {
    public let url: String?
    public let domain: String?
    public let title: String?
    public let subtitle: String?
    public let imageUrl: String?
    
    public init(url: String?) {
        self.url = url
        self.domain = nil
        self.title = nil
        self.subtitle = nil
        self.imageUrl = nil
    }
    
    public init(openGraph: OpenGraph?, url: String) {
        self.url = url
        self.domain = openGraph?[]
        self.title = openGraph?[.title]
        self.subtitle = openGraph?[.description]
        self.imageUrl = openGraph?[.image]
    }
}

extension MetaData: Equatable { }
