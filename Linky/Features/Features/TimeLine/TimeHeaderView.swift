//
//  TimeHeaderView.swift
//  Features
//
//  Created by chuchu on 12/28/23.
//

import UIKit

import Core

final class TimeHeaderView: UICollectionReusableView {
    static let identifier = description()
    
    let wrapperView = UIView()
    
    let label = UILabel().then {
        $0.text = ""
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 18)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
