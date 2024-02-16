//
//  SlackMessgeModel.swift
//  Core
//
//  Created by chuchu on 11/7/23.
//

import Foundation

// MARK: - SlackMessageModel
public class SlackMessageModel: Codable {
    var blocks: [SlackBlock]
    
    public init(blocks: [SlackBlock] = []) {
        self.blocks = blocks
    }
}

// MARK: - SlackMessageModel function
extension SlackMessageModel {
    @discardableResult
    public func addBlock(blockType: SlackBlock.BlockType) -> Self {
        let block = SlackBlock.makeBlock(block: blockType)
        self.blocks.append(block)
        return self
    }
}
