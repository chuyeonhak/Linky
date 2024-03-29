//
//  TagManageView.swift
//  Features
//
//  Created by chuchu on 2023/06/14.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagManageView: UIView {
    var selectedItems = Array(repeating: false, count: UserDefaultsManager.shared.tagList.count)
    let viewModel: TagManageViewModel!
    
    let titleLabel = UILabel().then {
        let tagCount = UserDefaultsManager.shared.tagList.count
        let text = I18N.tagCountText.replace(of: "COUNT", with: String(tagCount))
        
        $0.text = text
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 22)
    }
    
    let subtitleLabel = UILabel().then {
        $0.text = Const.Text.subtitle
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
        $0.numberOfLines = 2
    }
    
    let addTagButton = UIButton().then {
        $0.addCornerRadius(radius: 6)
        $0.backgroundColor = .main
        $0.setTitle(Const.Text.addTag, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 13)
    }
    
    lazy var tagTableView = UITableView().then {
        $0.backgroundColor = .code8
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.register(TagManageCell.self, forCellReuseIdentifier: TagManageCell.identifier)
    }
    
    init(viewModel: TagManageViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
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
        backgroundColor = .code8
        
        [titleLabel,
         subtitleLabel,
         addTagButton,
         tagTableView].forEach(addSubview)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(60)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(titleLabel)
        }
        
        addTagButton.snp.makeConstraints {
            let width = addTagButton.titleLabel?.textSize.width ?? .zero
            
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            $0.leading.equalTo(titleLabel)
            $0.width.equalTo(width + 20)
            $0.height.equalTo(36)
        }
        
        tagTableView.snp.makeConstraints {
            $0.top.equalTo(addTagButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
