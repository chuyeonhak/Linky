//
//  LockView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class LockView: UIView {
    let disposeBag = DisposeBag()
    
    let lockLabel = UILabel().then {
        $0.text = "화면 잠금"
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 15)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .code6
    }
    
    lazy var settingView = UIView().then {
        $0.backgroundColor = .code7
        $0.alpha = lockSwitch.isOn ? 1 : 0
    }
    
    let lockSwitch = UISwitch().then {
        $0.onTintColor = .main
    }
    
    lazy var changePasswordView = settingLockView(type: .changePassword)
    
    lazy var useBiometricsAuthView = settingLockView(type: .biometricsAuth)
    
    let biometricsAuthSwitch = UISwitch().then {
        $0.onTintColor = .main
    }
    
    lazy var warningLabel = UILabel().then {
        $0.text = "비밀번호를 잃어버릴 경우 앱을 재설치 해야 하며,\n저장된 링크는 모두 삭제됩니다."
        $0.textColor = .main
        $0.numberOfLines = 2
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
        $0.alpha = lockSwitch.isOn ? 1 : 0
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
        
        [lockLabel,
         lockSwitch,
         lineView,
         settingView,
         warningLabel].forEach(addSubview)
        
        [changePasswordView, useBiometricsAuthView].forEach(settingView.addSubview)
        
        useBiometricsAuthView.addSubview(biometricsAuthSwitch)
    }
    
    private func setConstraints() {
        lockLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.equalToSuperview().inset(20)
        }
        
        lockSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(lockLabel)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(lockLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        settingView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(96)
        }
        
        changePasswordView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        useBiometricsAuthView.snp.makeConstraints {
            $0.top.equalTo(changePasswordView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        biometricsAuthSwitch.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(settingView.snp.bottom).offset(14)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        lockSwitch.rx.isOn.changed
            .bind { [weak self] isOn in
                self?.fadeAnimation(isOn: isOn)
                if isOn {
                    self?.openLockScreen()
                }
            }.disposed(by: disposeBag)
    }

    private func settingLockView(type: LockSetting) -> UIView {
        let settingLockView = UIView()
        let titleLabel = UILabel().then {
            $0.text = type.title
            $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 13)
            $0.textColor = .code2
        }
        
        let lineView = UIView().then {
            $0.isHidden = !type.hasLine
            $0.backgroundColor = .code6
        }
        
        [titleLabel, lineView].forEach(settingLockView.addSubview)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        return settingLockView
    }
    
    private func fadeAnimation(isOn: Bool) {
        let alpha: CGFloat = isOn ? 0.0: 1.0
        
        [settingView,
         warningLabel].forEach {
            $0?.fadeInOut(startAlpha: alpha)
        }
    }
    
    private func openLockScreen() {
        let lockScreenVc = LockScreenViewController(type: .newPassword)
        
        lockScreenVc.modalPresentationStyle = .overFullScreen
        
        UIApplication.shared.window?.rootViewController?.present(lockScreenVc, animated: true)
    }
}
