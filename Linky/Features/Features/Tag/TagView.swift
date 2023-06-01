//
//  TagView.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class TagView: UIView {
    let emptyView = EmptyView(tabType: .tag)

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
        addSubview(emptyView)
    }
    
    private func setConstraints() {
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() { }
}

