//
//  EmptyView.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class EmptyView: UIView {
    let disposeBag = DisposeBag()
    
    var tabType: CustomTabBar.TabType!
    
    lazy var emptyImageView = UIImageView(image: tabType.emptyImage)
    
    lazy var emptyTitleLabel = UILabel().then {
        $0.text = tabType.emptyText
        $0.textColor = .code3
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 15)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    lazy var addLinkButton = UIButton().then {
        $0.addCornerRadius(radius: 10)
        $0.setTitle(tabType.addLinkTitle, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .main
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 15)
    }
    
    init(tabType: CustomTabBar.TabType) {
        self.tabType = tabType
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
        [emptyImageView,
         emptyTitleLabel,
         addLinkButton].forEach(addSubview)
    }
    
    private func setConstraints() {
        self.backgroundColor = .code7
        
        emptyImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-120)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        emptyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        addLinkButton.snp.makeConstraints {
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    private func bind() {
        addLinkButton.rx.tap
            .bind { [weak self] in self?.openAddLink() }
            .disposed(by: disposeBag)
    }
    
    private func openAddLink() {

        let tabBar = UIApplication.shared.window?.rootViewController as? RootViewController
        
        tabBar?.openAddLink()
    }
}
