//
//  TagCell.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

import Core

import SnapKit

class TagCell: UICollectionViewCell {
    let tagLabel = UILabel().then {
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
    }
    
    static let identifier = description()
    
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
        contentView.addCornerRadius(radius: 10)
        contentView.addSubview(tagLabel)
    }
    
    private func setConstraints() {
        tagLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(model: TestTag?) {
        guard let model else { return }
        
        var bgColor: UIColor? {
            model.isSelected ? Const.Custom.select.color: Const.Custom.deselect.color
        }
        
        var textColor: UIColor? {
            model.isSelected ? Const.Custom.selectText.color: Const.Custom.deselectText.color
        }
        contentView.backgroundColor = bgColor
        tagLabel.textColor = textColor
        tagLabel.text = model.title
    }
}
