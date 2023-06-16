//
//  TagManageCell.swift
//  Features
//
//  Created by chuchu on 2023/06/15.
//

import UIKit

import Core

import SnapKit
import Then

final class TagManageCell: UITableViewCell {
    static let identifier = description()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() { }
    
    private func setConstraints() { }
    
    private func bind() { }
}
