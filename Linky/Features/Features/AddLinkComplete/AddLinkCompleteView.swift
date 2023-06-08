//
//  AddLinkCompleteView.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkCompleteView: UIView {
    let emptyView = EmptyView(tabType: .link)
    
    lazy var homeButton = UIButton().then {
        $0.addCornerRadius(radius: 10)
        $0.setTitle("저장된 링크 보기", for: .normal)
        $0.setTitleColor(emptyView.addLinkButton.titleLabel?.textColor, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 15)
        $0.backgroundColor = .code4
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
        [emptyView, homeButton].forEach(addSubview)
    
    }
    
    private func setConstraints() {
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        homeButton.snp.makeConstraints {
            let addButton = emptyView.addLinkButton
            $0.top.equalTo(addButton.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.centerX.size.equalTo(addButton)
        }
    }
}
