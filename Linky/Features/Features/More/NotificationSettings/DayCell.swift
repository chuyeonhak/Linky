//
//  DayCell.swift
//  Features
//
//  Created by chuchu on 2023/07/18.
//

import UIKit

import Core

import SnapKit
import RxSwift

final class DayCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
    }
    
    private func addComponent() {
        contentView.addShadow(offset: CGSize(width: 0, height: 3), opacity: 0.08, blur: 4)
        contentView.addCornerRadius(radius: 6)
        contentView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(days: Days, isSelected: Bool) {
        let bgColor: UIColor? = isSelected ? .code6 : .code8
        let textColor: UIColor? = isSelected ? .code2: .code4
        let opacity: Float = isSelected ? 0.0: 0.08
        
        titleLabel.text = days.text
        titleLabel.textColor = textColor
        contentView.backgroundColor = bgColor
        contentView.layer.shadowOpacity = opacity
    }
}
