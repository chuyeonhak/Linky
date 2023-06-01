//
//  TimeLineView.swift
//  Features
//
//  Created by chuchu on 2023/05/17.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TimeLineView: UIView {
    let disposeBag = DisposeBag()
    
    let emptyView = EmptyView(tabType: .timeline)
    
    let timeLineTableView = UITableView()
    
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
        [emptyView, timeLineTableView].forEach(addSubview)
    }
    
    private func setConstraints() {
        timeLineTableView.isHidden = true
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLineTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
    }
}
