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
    let viewModel: AddLinkDetailViewModel!
    let disposeBag = DisposeBag()
    let metaData: MetaData!
    var selectedItems = Array(repeating: false, count: UserDefaultsManager.shared.tagList.count)
    var searchIndexPath: IndexPath?
    
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
        $0.returnKeyType = .done
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
    
    lazy var linkTitle = UILabel().then {
        $0.text = metaData.title
        $0.textColor = Const.Custom.linkTitle.color
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
    }
    
    lazy var linkSubtitle = UILabel().then {
        $0.text = metaData.subtitle
        $0.textColor = Const.Custom.subtitle.color
        $0.textAlignment = .left
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    lazy var linkLabel = UILabel().then {
        $0.text = metaData.url
        $0.textColor = Const.Custom.link.color
        $0.font = FontManager.shared.pretendard(weight: .regular, size: 13)
    }
    
    init(viewModel: AddLinkDetailViewModel, metaData: MetaData) {
        self.viewModel = viewModel
        self.metaData = metaData
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        linkInfoView.snp.makeConstraints {
            $0.top.equalTo(tagCollectionView.snp.bottom).offset(16)
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
    
    private func bind() {
        linkLineTextField.becomeFirstResponder()
        
        linkLineTextField.rx.controlEvent(.editingDidEndOnExit)
            .withUnretainedOnly(self)
            .bind { $0.tagLineTextField.becomeFirstResponder() }
            .disposed(by: disposeBag)
        
        tagLineTextField.rx.text
            .withUnretained(self)
            .bind { owner, text in
                let maxLenght = 8
                owner.tagLineTextField.maxLength(maxSize: maxLenght)
            }
            .disposed(by: disposeBag)
        
        tagLineTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind { [weak self] in self?.addTagList() }
            .disposed(by: disposeBag)
        
        tagCollectionView.rx.didEndScrollingAnimation
            .bind { [weak self] in self?.searchAnimation() }
            .disposed(by: disposeBag)
    }
    
    private func getCollectionViewHeight() -> Int {
        let itemLine = getCollectionViewLine()
        let limit = 5
        let isExceeded = itemLine > limit
        
        tagCollectionView.isScrollEnabled = isExceeded
        
        return (isExceeded ? limit: itemLine) * 37
    }
    
    private func getCollectionViewLine() -> Int {
        let deviceWidth = UIApplication.shared.window?.bounds.width ?? .zero
        let tagList = UserDefaultsManager.shared.tagList
        let inset: CGFloat = 42.0
        let collectionViewWidth = deviceWidth - (inset * 2)
        let textWidthArray = tagList.map { getItemWidth(text: $0.title) }
        
        var limit: CGFloat = collectionViewWidth
        var count: Int = tagList.isEmpty ? 0: 1
        
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
    
    private func addTagList() {
        guard let tagText = tagLineTextField.text,
              !tagText.isEmpty && tagText.count > 1,
              !isDuplicated(tagText: tagText)
        else { return }
        
        var copyArr = UserDefaultsManager.shared.tagList
        let tag = TagData(title: tagText, creationDate: Date())
        
        copyArr.append(tag)
        selectedItems.append(false)
        UserDefaultsManager.shared.tagList = copyArr
        
        tagLineTextField.text = ""
        
        configData()
    }
    
    private func isDuplicated(tagText: String) -> Bool {
        if case let tagList = UserDefaultsManager.shared.tagList,
           let firstIndex = tagList.firstIndex(where: { $0.title == tagText }),
           case let indexPath = IndexPath(item: firstIndex, section: 0) {
            
            tagCellAnimation(indexPath: indexPath)
            
            return true
        }
        
        return false
    }
    
    private func tagCellAnimation(indexPath: IndexPath) {
        if let cell = tagCollectionView.cellForItem(at: indexPath) as? TagCell {
            cell.shakeAnimation()
            HapticManager.shared.notification(.error)
        } else {
            searchIndexPath = indexPath
            
            tagCollectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func searchAnimation() {
        guard let searchIndexPath,
              let cell = tagCollectionView.cellForItem(at: searchIndexPath) as? TagCell
        else { return }
        
        cell.shakeAnimation()
        HapticManager.shared.notification(.error)
        
        self.searchIndexPath = nil
    }
    
    func configData(shouldScrollToBottom: Bool = true) {
        tagCollectionView.reloadData()
        
        tagCollectionView.snp.updateConstraints {
            let height = getCollectionViewHeight()
            
            $0.height.equalTo(height)
        }
        
        if shouldScrollToBottom { tagCollectionView.scrollsToBottom() }
    }
}

struct TestTag {
    let title: String
    var isSelected: Bool = false
}
