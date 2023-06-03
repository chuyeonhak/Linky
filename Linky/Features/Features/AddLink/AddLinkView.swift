//
//  AddLinkView.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkView: UIView {
    let disposeBag = DisposeBag()
    
    let canComplete = PublishSubject<Bool>()
    
    let addLinkTitle = UILabel().then {
        $0.text = Const.Text.addLinkTitle
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .bold, size: 22)
    }
    
    let linkTextFiled = LineTextField().then {
        $0.changePlaceholderTextColor(
            placeholderText: Const.Text.placeholder, textColor: .code4)
    }
    
    let pasteButton = UIButton().then {
        $0.setTitle(Const.Text.pasteButtonTitle, for: .normal)
        $0.setTitleColor(Const.Custom.buttonTitle.color, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 12)
        $0.backgroundColor = Const.Custom.buttonBG.color
        $0.addCornerRadius(radius: 4)
        $0.isHidden = true
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
        [addLinkTitle,
         linkTextFiled,
         pasteButton].forEach(addSubview)
    }
    
    private func setConstraints() {
        backgroundColor = .code8
        
        addLinkTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
        }
        
        linkTextFiled.snp.makeConstraints {
            $0.top.equalTo(addLinkTitle.snp.bottom).offset(56)
            $0.leading.trailing.equalToSuperview().inset(42)
            $0.height.equalTo(34)
        }
        
        pasteButton.snp.makeConstraints {
            $0.top.equalTo(linkTextFiled.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(26)
        }
    }
    
    private func bind() {
        let backgroundTapped = UITapGestureRecognizer()
        
        addGestureRecognizer(backgroundTapped)
        
        pasteButton.rx.tap
            .bind { [weak self] in
                self?.linkTextFiled.text = UIPasteboard.general.string
                self?.linkTextFiled.resignFirstResponder()
                self?.canComplete.onNext(true)
            }.disposed(by: disposeBag)
        
        linkTextFiled.rx.controlEvent(.editingChanged)
            .withUnretainedOnly(self)
            .map { !$0.linkTextFiledIsEmpty() }
            .bind(to: canComplete)
            .disposed(by: disposeBag)
        
        backgroundTapped.rx.event
            .bind { [weak self] _ in self?.linkTextFiled.resignFirstResponder() }
            .disposed(by: disposeBag)
    }
    
    private func linkTextFiledIsEmpty() -> Bool {
        let trimmedString = linkTextFiled.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return trimmedString?.isEmpty == true
    }
}

