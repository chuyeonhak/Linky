//
//  TimeLineView.swift
//  Features
//
//  Created by chuchu on 2023/05/17.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class TimeLineView: UIView {
    let emptyView = UIView()
    
    let clockImageView = UIImageView()
    
    let emptyTitleLabel = UILabel()
    
    let addLinkButton = UIButton()
    
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
        
        [clockImageView,
         emptyTitleLabel,
         addLinkButton].forEach(emptyView.addSubview)
    }
    
    private func setConstraints() {
        emptyView.backgroundColor = .white
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() { }
}
