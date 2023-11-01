//
//  TagCell.swift
//  Features
//
//  Created by chuchu on 2023/07/12.
//

import UIKit

import Core

final class TagGroupCell: UICollectionViewCell {
    let identifier = description()
    
    let wrapperView = UIView()
    
    let titleLabel = UILabel().then {
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        $0.textColor = .white
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
        addSubview(wrapperView)
        
        wrapperView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configure(tagTitle: String?) {
        titleLabel.text = tagTitle
    }
}
