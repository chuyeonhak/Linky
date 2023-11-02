//
//  TagGroupCell.swift
//  Features
//
//  Created by chuchu on 2023/07/12.
//

import UIKit

import Core

final class TagGroupCell: UICollectionViewCell {
    static let identifier = description()
    
    let wrapperView = UIView().then {
        
        $0.backgroundColor = UIColor(red: .random(in: 0.6...0.9),
                                     green: .random(in: 0.6...0.9),
                                     blue: .random(in: 0.6...0.9),
                                     alpha: 1)
        $0.addCornerRadius(radius: 12)
    }
    
    let titleLabel = UILabel().then {
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        $0.textColor = .white
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.3, blur: 5)
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
        contentView.addSubview(wrapperView)
        
        wrapperView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(tagTitle: String?) {
        titleLabel.text = tagTitle
    }
}
