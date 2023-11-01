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
    
    let lineView = UIView().then {
        $0.backgroundColor = .code6
    }
    
    let checkBoxImageView = UIImageView(image: Const.Custom.checkBoxOff.image)
    
    let titleLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 16)
    }
    
    let countLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        selectionStyle = .none
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        backgroundColor = .code7
        
        [lineView,
         checkBoxImageView,
         titleLabel,
         countLabel].forEach(contentView.addSubview)
    }
    
    private func setConstraints() {
        lineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        checkBoxImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalTo(20)
            $0.size.equalTo(32)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(checkBoxImageView.snp.trailing).offset(6)
            $0.centerY.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(5)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func bind() { }
    
    func configure(data: TagData, isSelected: Bool) {
        let asset = isSelected ? Const.Custom.checkBoxOn: Const.Custom.checkBoxOff
        
        titleLabel.text = data.title
        checkBoxImageView.image = asset.image
    }
}
