//
//  MoreView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

protocol SettingViewDelegate {
    func openNavigation(type: SettingType, hasLock: Bool)
}

final class MoreView: UIView {
    let disposeBag = DisposeBag()
    
    var delegate: SettingViewDelegate?
    
    lazy var settingStackView = UIStackView().then {
        $0.addCornerRadius(radius: 12)
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.08, blur: 10)
        $0.axis = .vertical
        $0.distribution = .fillEqually
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
        addSubview(settingStackView)
        configSettingViews()
    }
    
    private func setConstraints() {
        backgroundColor = .code7
        
        settingStackView.backgroundColor = .code8
        settingStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(SettingType.allCases.count * 60)
        }
    }
    
    private func configSettingViews() {
        SettingType.allCases.forEach { type in
            let settingView = MoreSettingView(),
                settingViewTapped = UITapGestureRecognizer()
            
            settingView.configure(type: type)
            settingView.addGestureRecognizer(settingViewTapped)
            
            settingViewTapped.rx.event
                .bind { [weak self] _ in
                    self?.delegate?.openNavigation(type: type, hasLock: true)
                }.disposed(by: disposeBag)
            
            settingStackView.addArrangedSubview(settingView)
        }
    }
    
    private func bind() { }
}

