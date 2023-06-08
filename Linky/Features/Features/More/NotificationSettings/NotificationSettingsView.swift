//
//  NotificationSettingsView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class NotificationSettingsView: UIView {
    
    let notificationLabel = UILabel().then {
        $0.text = "알림 사용"
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 15)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .code6
    }
    
    let settingView = UIView()
    
    let notificationSwitch = UISwitch().then {
        $0.onTintColor = .main
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
        backgroundColor = .code8
        
        [notificationLabel,
         notificationSwitch,
         lineView].forEach(addSubview)
    }
    
    private func setConstraints() {
        notificationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.equalToSuperview().inset(20)
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalTo(notificationLabel)
            $0.width.equalTo(40)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() { }
}

