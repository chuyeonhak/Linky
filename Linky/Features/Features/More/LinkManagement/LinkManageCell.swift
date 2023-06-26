//
//  LinkManageCell.swift
//  Features
//
//  Created by chuchu on 2023/06/22.
//

import UIKit

import Core

import SnapKit
import Then

final class LinkManageCell: UICollectionViewCell {
    static let identifier = description()
    
    let checkBoxImageView = UIImageView(image: TagManageCell.Const.Custom.checkBoxOff.image)
    
    let wrapperView = UIView().then {
        $0.addCornerRadius(radius: 12)
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.08, blur: 4)
        $0.backgroundColor = .white
    }
    
    let linkImageView = UIImageView()
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    let topView = UIView()
    
    let dateLabel = UILabel().then {
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 11)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .code5
    }
    
    let isWrittenLabel = UILabel().then {
        $0.text = "안읽음"
        $0.textColor = .code5
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 11)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
    }
    
    let bottomView = UIView()
    
    let domainLabel = UILabel().then {
        $0.text = "네이버"
        $0.textColor = .sub
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 12)
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = "나나방콕 상무점"
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
    
    private func addComponent() {
        backgroundColor = .code8
        
        [checkBoxImageView,
         wrapperView].forEach(contentView.addSubview)
        
        [linkImageView,
         contentStackView].forEach(wrapperView.addSubview)
        
        [topView,
         titleLabel,
         bottomView].forEach(contentStackView.addArrangedSubview)
        
        [dateLabel,
         lineView,
         isWrittenLabel].forEach(topView.addSubview)
        
        [domainLabel, subtitleLabel].forEach(bottomView.addSubview)
    }
    
    private func setConstraints() {
        checkBoxImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalTo(20)
            $0.size.equalTo(32)
        }
        
        wrapperView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalTo(checkBoxImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(22)
            $0.height.equalTo(72)
        }
        
        linkImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(72)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(linkImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.leading.equalTo(dateLabel.snp.trailing).offset(4)
            $0.width.equalTo(1)
            $0.height.equalTo(8)
            $0.centerY.equalTo(dateLabel)
        }
        
        isWrittenLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(lineView.snp.trailing).offset(4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
        
        domainLabel.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(domainLabel.snp.trailing).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() { }
    
    func configure(link: Link, isSelected: Bool) {
        let custom = TagManageCell.Const.Custom.self
        let asset = isSelected ? custom.checkBoxOn: custom.checkBoxOff
        
        titleLabel.text = link.content.title
        dateLabel.text = link.dateText
        checkBoxImageView.image = asset.image
    }
}
