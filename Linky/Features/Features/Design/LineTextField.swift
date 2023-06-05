//
//  LineTextField.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class LineTextField: UITextField {
    private let lineView = UIView().then {
        $0.backgroundColor = .code1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setTextField()
        addComponent()
        setConstraints()
        bind()
    }
    
    private func setTextField() {
        textColor = .code2
        tintColor = .code4
        
        if let clearButton = value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: "icoClose"), for: .normal)
        }
        
        clearButtonMode = .whileEditing
    }
    
    private func addComponent() {
        addSubview(lineView)
    }
    
    private func setConstraints() {
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    private func bind() { }
}

