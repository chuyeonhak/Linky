//
//  TimeLineLinkCell.swift
//  Features
//
//  Created by chuchu on 2023/07/04.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TimeLineLinkCell: UICollectionViewCell {
    static let identifier = description()
    
    private var link: Link?
    var disposeBag = DisposeBag()
    
    let wrapperView = UIView().then {
        $0.addCornerRadius(radius: 12)
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.08, blur: 4)
        $0.backgroundColor = .code8
    }
    
    let linkImageView = UIImageView().then {
        $0.addCornerRadius(radius: 4)
        $0.layer.masksToBounds = true
    }
    
    let contentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 7
    }
    
    let topView = UIView()
    
    let dateLabel = UILabel().then {
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 11)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .code4
    }
    
    let isWrittenLabel = UILabel().then {
        $0.text = "안읽음"
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 11)
    }
    
    let moreButton = UIButton().then {
        $0.setImage(UIImage(named: "icoMore"), for: .normal)
        $0.showsMenuAsPrimaryAction = true
    }
        
    let memoLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
        $0.numberOfLines = 2
    }
    
    let tagScrollView = UIScrollView().then {
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        $0.showsHorizontalScrollIndicator = false
    }
    
    let tagStackView = UIStackView().then {
        $0.spacing = 3
    }
    
    let horizontalLineView = UIView().then {
        $0.backgroundColor = .code5
    }
    
    let bottomView = UIView()
    
    let titleLabel = UILabel().then {
        $0.text = "나나방콕 상무점"
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 12)
    }
    
    let copyButton = UIButton().then {
        $0.setImage(UIImage(named: "icoCopy"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        backgroundColor = .code7
        
        contentView.addSubview(wrapperView)
        
        [topView,
         moreButton,
         linkImageView,
         contentStackView,
         bottomView].forEach(wrapperView.addSubview)
        
        [dateLabel,
         lineView,
         isWrittenLabel].forEach(topView.addSubview)
        
        [memoLabel,
         tagScrollView].forEach(contentStackView.addArrangedSubview)
        
        tagScrollView.addSubview(tagStackView)
                
        [horizontalLineView,
         titleLabel,
         copyButton].forEach(bottomView.addSubview)
    }
    
    private func setConstraints() {
        wrapperView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        topView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(12)
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
        
        moreButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(4)
            $0.trailing.equalToSuperview().inset(10)
            $0.size.equalTo(24)
        }
        
        linkImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.leading.equalTo(topView)
            $0.size.equalTo(98)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(linkImageView)
            $0.leading.equalTo(linkImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        tagScrollView.snp.makeConstraints {
            $0.height.equalTo(17)
        }
        
        tagStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints {
            $0.bottom.equalTo(linkImageView)
            $0.leading.trailing.equalTo(contentStackView)
            $0.height.equalTo(28)
        }
        
        horizontalLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(52)
        }
        
        copyButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview()
            $0.width.equalTo(28)
            $0.height.equalTo(20)
        }
    }
    
    func configure(link: Link) {
        self.link = link
        
        let isWrittenText = link.isWrittenCount == 0 ? "안읽음": "\(link.isWrittenCount)번 읽음"
        
        memoLabel.text = link.linkMemo
        dateLabel.text = link.dateToString
        titleLabel.text = link.content?.title
        isWrittenLabel.text = isWrittenText
        
        setImageData(data: link.content?.imageData)
        addTagList(tagList: link.tagList)
    }
    
    private func setImageData(data: Data?) {
        let hasImageData = data != nil,
            imageWidth = hasImageData ? 98: 0,
            stackViewOffset = hasImageData ? 12 : 0
        
        setImage(imageData: data)
        linkImageView.snp.updateConstraints { $0.width.equalTo(imageWidth) }
        contentStackView.snp.updateConstraints {
            $0.leading.equalTo(linkImageView.snp.trailing).offset(stackViewOffset)
        }
    }
    
    private func setImage(imageData: Data?) {
        guard let imageData else {
            linkImageView.image = nil
            return
        }
        
        linkImageView.image = UIImage(data: imageData)
    }
    
    private func addTagList(tagList: [TagData]) {
        tagStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        
        tagList.map(makeTagView)
            .forEach(tagStackView.addArrangedSubview)
        
    }
    
    private func makeTagView(tagData: TagData) -> UIView {
        let view = UIView().then {
            $0.backgroundColor = .alphaCode1
            $0.addCornerRadius(radius: 4)
        }
        
        let label = UILabel().then {
            $0.text = tagData.title
            $0.textColor = .code3
            $0.font = FontManager.shared.pretendard(weight: .regular, size: 11)
        }
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(2)
            $0.leading.trailing.equalToSuperview().inset(4)
        }
        
        return view
    }
}
