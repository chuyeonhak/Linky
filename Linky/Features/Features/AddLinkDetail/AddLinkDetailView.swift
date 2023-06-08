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
    
    lazy var tagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CollectionViewLeftAlignFlowLayout()).then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        }
    
    let lineView = UIView().then {
        $0.backgroundColor = Const.Custom.line.color
    }
    
    let linkInfoView = UIView().then {
        $0.backgroundColor = Const.Custom.linkInfoBG.color
    }
    
    let linkTitle = UILabel().then {
        $0.text = "네이버 지도"
        $0.textColor = Const.Custom.linkTitle.color
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
    }
    
    let linkSubtitle = UILabel().then {
        $0.text = "나나방콕 상무점"
        $0.textColor = Const.Custom.subtitle.color
        $0.textAlignment = .left
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    let linkLabel = UILabel().then {
        $0.text = "www.naver.com"
        $0.textColor = Const.Custom.link.color
        $0.font = FontManager.shared.pretendard(weight: .regular, size: 13)
    }
    
    var testArray: [TestTag] = [
        TestTag(title: "웃긴거"),
        TestTag(title: "# 데이트"),
        TestTag(title: "맛집"),
        TestTag(title: "카페"),
        TestTag(title: "강의"),
        TestTag(title: "wowoooowwww"),
        TestTag(title: "테스트 입니다아아아아아아앙"),
    ]
    
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
         tagCollectionView,
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
        
        tagCollectionView.snp.makeConstraints {
            let height = getCollectionViewHeight()
            
            $0.top.equalTo(tagLineTextField.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(tagLineTextField)
            $0.height.equalTo(height)
        }
        
        linkInfoView.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(36)
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
            $0.trailing.lessThanOrEqualToSuperview().inset(20)
        }
        
        linkLabel.snp.makeConstraints {
            $0.top.equalTo(linkTitle.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
    }
    
    private func bind() { }
    
    private func getCollectionViewHeight() -> Int {
        let itemLine = getCollectionViewLine()
        let itemHeight = 37
        let limit = 5
        let isExceeded = itemLine > limit
        
        tagCollectionView.isScrollEnabled = isExceeded
        
        return (isExceeded ? limit: itemLine) * 37
    }
    
    private func getCollectionViewLine() -> Int {
        let deviceWidth = UIApplication.shared.window?.bounds.width ?? .zero
        let inset: CGFloat = 42.0
        let collectionViewWidth = deviceWidth - (inset * 2)
        let textWidthArray = testArray.map { getItemWidth(text: $0.title) }
        
        var limit: CGFloat = collectionViewWidth
        var count: Int = testArray.isEmpty ? 0: 1
        
        for (index, textWidth) in textWidthArray.enumerated() {
            let currentWidth = textWidth + 4 // itemSpacing
            
            if let next = textWidthArray[safe: index + 1],
               case let nextWidth = next + 4,
               limit - (currentWidth + nextWidth) < 0 {
                count += 1
                limit = collectionViewWidth
            } else {
                limit -= currentWidth
            }
        }
        
        return count
    }
}

struct TestTag {
    let title: String
    var isSelected: Bool = false
}
