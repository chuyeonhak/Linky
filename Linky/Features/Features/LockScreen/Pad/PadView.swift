//
//  PadView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class PadView: UIView {
    let type: PadType!
    
    lazy var padLabel = UILabel().then {
        let fontSize: CGFloat = type == .cancel ? 18.0: 22.0
        
        $0.text = type.title
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .medium, size: fontSize)
    }
    
    lazy var padImageView = UIImageView(image: type.image)
    
    var isPlaying: Bool = false
    
    init(type: PadType) {
        self.type = type
        super.init(frame: .zero)
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
        backgroundColor = .code8
        
        [padLabel, padImageView].forEach(addSubview)
    }
    
    private func setConstraints() {
        padLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        padImageView.snp.makeConstraints {
            let size = type == .biometricsAuth ?
            CGSize(width: 24, height: 24):
            CGSize(width: 26, height: 20)
            
            $0.center.equalToSuperview()
            $0.size.equalTo(size)
        }
    }
    
    private func bind() { }
    
    func setBackgroundColor(isSelect: Bool) {
        UIView.animate(withDuration: 0.25) {
            let bgColor: UIColor? = isSelect ? .code7 : .code8
            self.backgroundColor = bgColor
        }
    }
}


