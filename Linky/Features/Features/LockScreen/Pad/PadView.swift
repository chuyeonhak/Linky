//
//  PadView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class PadView: UIView {
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
    
    private func addComponent() { }
    
    private func setConstraints() { }
    
    private func bind() { }
}

