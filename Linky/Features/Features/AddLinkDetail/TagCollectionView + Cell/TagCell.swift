//
//  TagCell.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

import Core

import SnapKit
import RxSwift

class TagCell: UICollectionViewCell {
    var disposeBag = DisposeBag()
    
    let tagLabel = UILabel().then {
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
    }
    
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "icoDelete"), for: .normal)
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
        contentView.addCornerRadius(radius: 10)
        [tagLabel, deleteButton].forEach(contentView.addSubview)
    }
    
    private func setConstraints() {
        tagLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(tagLabel.snp.trailing)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(20)
            $0.height.equalTo(29)
        }
    }
    
    func configure(tagData: TagData, isSelected: Bool) {
        let custom = Const.Custom.self
        let bg = isSelected ? custom.select: custom.deselect
        let text = isSelected ? custom.selectText: custom.deselectText
        
        contentView.backgroundColor = bg.color
        tagLabel.textColor = text.color
        tagLabel.text = tagData.title
    }
}
