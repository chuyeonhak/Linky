//
//  SlackBlock.swift
//  Core
//
//  Created by chuchu on 11/7/23.
//

import Foundation

// MARK: - Block
public struct SlackBlock: Codable {
    let type: String
    let text: SlackText?
    var imageURL: String?
    var altText: String?

    enum CodingKeys: String, CodingKey {
        case type, text
        case imageURL = "image_url"
        case altText = "alt_text"
    }
    
    public init(type: String, text: SlackText?, imageURL: String? = nil, altText: String? = nil) {
        self.type = type
        self.text = text
        self.imageURL = imageURL
        self.altText = altText
    }
}


//MARK: SlackBlock Enum
extension SlackBlock {
    public enum BlockType {
        case header(String)
        case title(String)
        case contents(String)
        case image
        case divider
        
        var type: String {
            switch self {
            case .header(_): "header"
            case .title(_), .contents(_): "section"
            case .image: "image"
            case .divider: "divider"
            }
        }
        
        var text: SlackText {
            switch self {
            case .header(let text): SlackText(type: "plain_text", text: text)
            case .title(let text): SlackText(type: "mrkdwn", text: "*제목*\n" + text)
            case .contents(let text): SlackText(type: "mrkdwn", text: "*내용*\n" + text)
            case .image: SlackText(type: type, text: "")
            case .divider: SlackText(type: type, text: "")
            }
        }
    }
}


//MARK: SlackBlock function
extension SlackBlock {
    public static func makeBlock(block: BlockType) -> SlackBlock {
        switch block {
        case .header(_), .title(_), .contents(_): SlackBlock(type: block.type, text: block.text)
        case .image: SlackBlock(type: block.type, text: nil, imageURL: nil, altText: nil)
        case .divider: SlackBlock(type: block.type, text: nil)
        }
    }
}
