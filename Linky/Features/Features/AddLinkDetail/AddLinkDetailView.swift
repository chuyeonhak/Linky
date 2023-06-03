//
//  AddLinkDetailView.swift
//  Features
//
//  Created by chuchu on 2023/06/03.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkDetailView: UIView {
    let memoLinkLabel = UILabel().then {
        $0.text = Const.Text.linkTitle
        $0.textColor = Const.Custom.subtitle.color
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    let linkLineTextField = LineTextField().then {
        $0.changePlaceholderTextColor(
            placeholderText: Const.Text.linkPlaceholder, textColor: .code4)
    }
    
    let addTagLabel = UILabel().then {
        $0.text = Const.Text.addTagTitle
        $0.textColor = Const.Custom.subtitle.color
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    let tagLineTextField = LineTextField().then {
        $0.changePlaceholderTextColor(
            placeholderText: Const.Text.tagPlaceholder, textColor: .code4)
    }
    
    let linkCollectionView = UIView()
    
    let lineView = UIView().then {
        $0.backgroundColor = Const.Custom.line.color
    }
    
    let linkInfoView = UIView().then {
        $0.backgroundColor = Const.Custom.linkInfoBG.color
    }
    
    let linkTitle = UILabel().then {
        $0.text = "네이버 지도"
        $0.textColor = Const.Custom.linkTitle.color
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 12)
    }
    
    let linkSubtitle = UILabel().then {
        $0.text = "나나방콕 상무점"
        $0.textColor = Const.Custom.subtitle.color
        $0.textAlignment = .left
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    let linkLabel = UILabel().then {
        $0.text = "www.naver.com"
        $0.textColor = Const.Custom.link.color
        $0.font = FontManager.shared.pretendard(weight: .regular, size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        [memoLinkLabel,
         linkLineTextField,
         addTagLabel,
         tagLineTextField,
         linkCollectionView,
         linkInfoView].forEach(addSubview)
        
        [lineView,
         linkTitle,
         linkSubtitle,
         linkLabel].forEach(linkInfoView.addSubview)
    }
    
    private func setConstraints() {
        backgroundColor = .code8
        
        memoLinkLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32)
            $0.leading.equalToSuperview().inset(42)
        }
        
        linkLineTextField.snp.makeConstraints {
            $0.top.equalTo(memoLinkLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.height.equalTo(34)
        }
        
        addTagLabel.snp.makeConstraints {
            $0.top.equalTo(linkLineTextField.snp.bottom).offset(32)
            $0.leading.equalTo(memoLinkLabel)
        }
        
        tagLineTextField.snp.makeConstraints {
            $0.top.equalTo(addTagLabel.snp.bottom).offset(8)
            $0.leading.trailing.height.equalTo(linkLineTextField)
        }
        
        linkCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagLineTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(tagLineTextField)
            $0.height.equalTo(66)
        }
        
        linkInfoView.snp.makeConstraints {
            $0.top.equalTo(linkCollectionView.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(64)
        }
        
        lineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        linkTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
        }
        
        linkSubtitle.snp.makeConstraints {
            $0.top.equalTo(linkTitle)
            $0.leading.equalTo(linkTitle.snp.trailing).offset(4)
            $0.trailing.greaterThanOrEqualToSuperview().inset(20)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(linkTitle.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    private func bind() { }
}
