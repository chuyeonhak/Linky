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
    let emptyView = UIView()
    
    let clockImageView = UIImageView(image: UIImage(named: "clock"))
    
    let emptyTitleLabel = UILabel().then {
        $0.text = "내가 추가한 링크를\n시간 순서대로 볼 수 있어요."
        $0.textColor = UIColor(red: 231, green: 232, blue: 235, alpha: 1)
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 15)
    }
    
    let addLinkButton = UIButton().then {
        $0.addCornerRadius(radius: 10)
        $0.setTitle("링크 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .main
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 15)
    }
    
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
        emptyView.backgroundColor = .black
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        timeLineTableView.isHidden = true
        timeLineTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        clockImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-80)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        
        emptyTitleLabel.snp.makeConstraints {
            $0.top.equalTo(clockImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        
        addLinkButton.snp.makeConstraints {
            $0.top.equalTo(emptyTitleLabel.snp.bottom).offset(70)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(312)
            $0.height.equalTo(46)
        }
        
        
    }
    
    private func bind() { }
}
