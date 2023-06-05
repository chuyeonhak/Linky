//
//  AddLinkCompleteView.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class AddLinkCompleteView: UIView {
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
        self.backgroundColor = .code8
    }
    
    private func setConstraints() { }
    
    private func bind() { }
}

