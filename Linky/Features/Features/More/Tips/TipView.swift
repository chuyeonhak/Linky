//
//  TipView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then

final class TipView: UIView {
    let scrollView = UIScrollView()
    
    let tipImageView = UIImageView(image: UIImage(named: "tips")).then {
        $0.isUserInteractionEnabled = true
    }
    
    let shareButton = UIButton().then {
        $0.addCornerRadius(radius: 10)
        $0.setTitle("링키 바로 추가하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .main
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 15)
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
        backgroundColor = .code7
        
        addSubview(scrollView)
        scrollView.addSubview(tipImageView)
        tipImageView.addSubview(shareButton)
    }
    
    private func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tipImageView.snp.makeConstraints {
            $0.top.centerX.bottom.equalToSuperview()
            $0.width.equalTo(375)
        }
        
        shareButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(56)
        }
    }
}

