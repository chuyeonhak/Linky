//
//  MoreSettingView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class MoreSettingView: UIView {
    static let identifier = description()
    
    let iconImageView = UIImageView()
    
    let titleLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 16)
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .code7
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
    }
    
    private func addComponent() {
        [iconImageView,
         titleLabel,
         separatorView].forEach(addSubview)
    }
    
    private func setConstraints() {
        iconImageView.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(12)
            $0.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(iconImageView)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(type: SettingType) {
        backgroundColor = .clear
        iconImageView.image = type.image
        titleLabel.text = type.title
        separatorView.isHidden = type == .synchronizationGuide
    }
}
