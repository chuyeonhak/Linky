//
//  LockScreenView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class LockScreenView: UIView {
    let type: LockType!
    let disposeBag = DisposeBag()
    
    lazy var titleLabel = UILabel().then {
        $0.text = type.title
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 22)
        
    }
    
    lazy var subtitleLabel = UILabel().then {
        $0.text = type.subtitle
        $0.textColor = .code4
        $0.font = FontManager.shared.pretendard(weight: .medium, size: 13)
    }
    
    let passwordStackView = UIStackView().then {
        $0.distribution = .fillEqually
        $0.spacing = 12
    }
    
    let padWrapperStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    var padViews: [PadView] = []
    
    init(type: LockType) {
        self.type = type
        super.init(frame: .zero)
        commonInit()
        print(type)
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
        
        [titleLabel,
         subtitleLabel,
         passwordStackView,
         padWrapperStackView].forEach(addSubview)
        
        setPasswordView()
        setPadView()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(150)
            $0.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        passwordStackView.snp.makeConstraints {
            $0.top.equalTo(subtitleLabel.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(84)
            $0.height.equalTo(12)
        }
        
        padWrapperStackView.snp.makeConstraints {
            let height = UIScreen.main.bounds.width / 6 * 4
            
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(height)
        }
    }
    
    private func bind() {
        let padPanGesture = UIPanGestureRecognizer()
        
        padWrapperStackView.addGestureRecognizer(padPanGesture)
        
        padPanGesture.rx.event
            .bind { [weak self] in self?.padPanGesture(pan: $0) }
            .disposed(by: disposeBag)
    }
    
    private func setPasswordView() {
        (0...3).forEach { _ in
            let view = UIView()
            
            view.addCornerRadius(radius: 6)
            view.backgroundColor = .code5
            
            passwordStackView.addArrangedSubview(view)
        }
    }
    
    private func setPadView() {
        for row in type.pads {
            let rowStackView = getRowStackView(pads: row)
            
            padWrapperStackView.addArrangedSubview(rowStackView)
        }
    }
    
    private func getRowStackView(pads: [PadView.PadType]) -> UIStackView {
        let rowStackView = UIStackView()
        
        rowStackView.distribution = .fillEqually
        
        for pad in pads {
            let padView = PadView(type: pad)
            let padViewTapped = UITapGestureRecognizer()
            
            padView.addGestureRecognizer(padViewTapped)
            
            padViewTapped.rx.event
                .bind { [weak self] _ in self?.padTapEvent(type: pad) }
                .disposed(by: disposeBag)
            
            rowStackView.addArrangedSubview(padView)
            self.padViews.append(padView)
        }
        
        return rowStackView
    }
    
    private func padTapEvent(type: PadView.PadType) {
        switch type {
        case .number(let num):
            print(num)
        case .cancle:
            print("cancle")
        case .biometricsAuth:
            print("biometricsAuth")
        case .back:
            print("back")
        }
    }
    
    private func padPanGesture(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self)
//        print(padWrapperStackView.frame.contains(location))
//        padViews[1].convert(padWrapperStackView, to: self)
//        print(location)
        let view = padViews.first {
            self.convert($0.frame, from: padWrapperStackView.arrangedSubviews[0]).contains(location)
        }
        
        view?.setBackgroundColor(isSelect: true)
        
//        print(convert(padViews[1].frame, from: padWrapperStackView.arrangedSubviews[0]))
//        print(convert(padViews[1].frame, to: padWrapperStackView).contains(location))
//        print(convert(padViews[1].frame, from: self).contains(location))
    }
}



