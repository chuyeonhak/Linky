//
//  MoreView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class MoreView: UIView {
    lazy var tableView = UITableView().then {
        $0.addCornerRadius(radius: 12)
        $0.separatorStyle = .none
        $0.allowsSelection = false
//        $0.isScrollEnabled = false
        $0.delegate = self
        $0.dataSource = self
        $0.register(MoreCell.self, forCellReuseIdentifier: MoreCell.identifier)
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.16, blur: 10)
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
        bind()
    }
    
    private func addComponent() {
        addSubview(tableView)
    }
    
    private func setConstraints() {
        backgroundColor = .code7
        
        tableView.backgroundColor = .code8
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(288)
        }
    }
    
    private func bind() { }
}

