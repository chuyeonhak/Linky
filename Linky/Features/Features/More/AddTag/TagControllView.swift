//
//  TagControlView.swift
//  Features
//
//  Created by chuchu on 2023/06/16.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagControlView: UIView {
    let type: TagManageType!
    let disposeBag = DisposeBag()
    
    var tagData: TagData?
    
    let canComplete = PublishSubject<Bool>()
    
    lazy var titleLabel = UILabel().then {
        $0.text = type.title
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 22)
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.text = type.subtitle
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    lazy var lineTextField = LineTextField().then {
        $0.text = tagData?.title
        $0.placeholder = type.placeholder
    }
    
    init(type: TagManageType, tagData: TagData? = nil) {
        self.type = type
        self.tagData = tagData
        
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
        
        [titleLabel,
         subtitleLabel,
         lineTextField].forEach(addSubview)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        lineTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.height.equalTo(34)
        }
    }
    
    private func bind() {
        lineTextField.rx.text
            .withUnretained(self)
            .bind { owner, text in
                let maxLenght = 8
                let textCount = text?.count ?? 0
                owner.lineTextField.maxLength(maxSize: maxLenght)
                owner.canComplete.onNext(textCount > 1)
            }
            .disposed(by: disposeBag)
    }
}

