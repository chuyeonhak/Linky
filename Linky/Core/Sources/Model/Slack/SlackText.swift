//
//  SlackText.swift
//  Core
//
//  Created by chuchu on 11/7/23.
//

import Foundation

// MARK: - Text
public struct SlackText: Codable {
    let type, text: String
    
    public init(type: String, text: String) {
        self.type = type
        self.text = text
    }
}
