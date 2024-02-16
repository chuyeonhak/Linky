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

public final class AddLinkDetailView: UIView {
    let viewModel: AddLinkDetailViewModel!
    let disposeBag = DisposeBag()
    let metaData: MetaData!
    public var selectedItems = Array(repeating: false, count: UserDefaultsManager.shared.tagList.count)
    var searchIndexPath: IndexPath?
    var link: Link?
    
    let memoLinkLabel = UILabel().then {
        $0.text = Const.Text.linkTitle
        $0.textColor = Const.Custom.subtitle.color
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    public let linkLineTextField = LineTextField().then {
        $0.changePlaceholderTextColor(
            placeholderText: Const.Text.linkPlaceholder, textColor: .code5)
    }
    
    let addTagLabel = UILabel().then {
        $0.text = Const.Text.addTagTitle
        $0.textColor = Const.Custom.subtitle.color
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    public let tagLineTextField = LineTextField().then {
        $0.changePlaceholderTextColor(
            placeholderText: Const.Text.tagPlaceholder, textColor: .code5)
        $0.returnKeyType = .done
    }
    
    public lazy var tagCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: TagLeftAlignFlowLayout()).then {
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
    
    public init(viewModel: AddLinkDetailViewModel,
         metaData: MetaData,
         link: Link?) {
        self.viewModel = viewModel
        self.metaData = metaData
        self.link = link
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
        linkCheck()
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
    
    private func linkCheck() {
        guard let link,
              case let tagList = UserDefaultsManager.shared.tagList else { return }
        
        linkLineTextField.text = link.linkMemo
        for tag in link.tagList {
            if tagList.contains(tag),
               let firstIndex = tagList.firstIndex(of: tag),
               selectedItems.indices ~= firstIndex {
                selectedItems[firstIndex] = true
            }
        }
        
        tagCollectionView.reloadData()
    }
    
    private func getCollectionViewHeight() -> Int {
        let itemLine = getCollectionViewLine()
        let limit = 5
        let isExceeded = itemLine > limit
        
        tagCollectionView.isScrollEnabled = isExceeded
        
        return (isExceeded ? limit: itemLine) * 37
    }
    
    private func getCollectionViewLine() -> Int {
        let deviceWidth = UIScreen.main.bounds.width
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
    
    public func addTagList() {
        guard let tagText = tagLineTextField.text,
              !tagText.isEmpty && tagText.count > 0,
              !isDuplicated(tagText: tagText)
        else { return }
        
        var copyArr = UserDefaultsManager.shared.tagList
        let tag = TagData(title: tagText, createdAt: Date())
        
        copyArr.append(tag)
        selectedItems.append(true)
        UserDefaultsManager.shared.tagList = copyArr
        
        tagLineTextField.text = ""
        
        setCollectionViewHeight()
    }
    
    private func isDuplicated(tagText: String) -> Bool {
        if case let tagList = UserDefaultsManager.shared.tagList,
           let firstIndex = tagList.firstIndex(where: { $0.title == tagText }),
           case let indexPath = IndexPath(item: firstIndex, section: 0) {
            
            selectedItems[firstIndex] = true
            UIView.performWithoutAnimation {
                tagCollectionView.reloadItems(at: [indexPath])
            }
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
    
    public func setCollectionViewHeight(isDeleted: Bool = false) {
        let height = getCollectionViewHeight(),
            shouldScrollToBottom = height == 5 * 37 && !isDeleted
        tagCollectionView.reloadData()
        
        tagCollectionView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            if shouldScrollToBottom { self.tagCollectionView.scrollsToBottom() }
        }
    }
    
    public func configMetaData(metaData: MetaData) {
        DispatchQueue.main.async {
            self.linkLabel.text = metaData.url
            self.linkTitle.text = metaData.title
            self.linkSubtitle.text = metaData.subtitle
        }
    }
}
