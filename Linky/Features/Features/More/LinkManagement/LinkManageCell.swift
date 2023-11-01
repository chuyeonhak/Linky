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
        $0.backgroundColor = .code8
    }
    
    let bottomLineView = UIView().then {
        $0.backgroundColor = .code6
    }
    
    let linkImageView = UIImageView().then {
        $0.addCornerRadius(radius: 8)
        $0.layer.masksToBounds = true
    }
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }
    
    let bottomView = UIView()
    
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
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 15)
    }
    
    let urlLabel = UILabel().then {
        $0.text = "www.linky.com"
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
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
        
        [wrapperView,
         bottomLineView].forEach(contentView.addSubview)
        
        [linkImageView,
         contentStackView,
         checkBoxImageView].forEach(wrapperView.addSubview)
        
        [titleLabel,
         urlLabel,
         bottomView].forEach(contentStackView.addArrangedSubview)
        
        [dateLabel,
         lineView,
         isWrittenLabel].forEach(bottomView.addSubview)
    }
    
    private func setConstraints() {
        wrapperView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(22)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        linkImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.size.equalTo(56)
        }
        
        checkBoxImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(32)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.equalTo(linkImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(checkBoxImageView.snp.leading).offset(-27)
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
    }
    
    private func bind() { }
    
    func configure(link: Link, isSelected: Bool) {
        let custom = TagManageCell.Const.Custom.self
        let asset = isSelected ? custom.checkBoxOn: custom.checkBoxOff
        let isWrittenText = link.isWrittenCount == 0 ? "안 읽음": "\(link.isWrittenCount)번 읽음"
        
        titleLabel.text = link.content?.title ?? " "
        urlLabel.text = link.content?.url
        dateLabel.text = link.dateToString
        isWrittenLabel.text = isWrittenText
        checkBoxImageView.image = asset.image
        setImageData(data: link.content?.imageData)
    }
    
    private func setImageData(data: Data?) {
        if let data {
            linkImageView.image = UIImage(data: data)
        } else {
            linkImageView.image = UIImage(named: "nonImage")
        }
    }
}
