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
    let viewModel: LockScreenViewModel!
    
    let disposeBag = DisposeBag()
    
    let vibrator = UINotificationFeedbackGenerator().then {
        $0.prepare()
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 22)
        
    }
    
    let subtitleLabel = UILabel().then {
        
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
    
    init(viewModel: LockScreenViewModel) {
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
            let height = UIScreen.main.bounds.height * 0.4
            
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
        
        viewModel.output?.lockType
            .drive { [weak self] in self?.setLockType(type: $0) }
            .disposed(by: disposeBag)
        
        
        viewModel.output?.passwordCount
            .drive { [weak self] in self?.setPasswordView(passwordCount: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.passwordError
            .drive { [weak self] _ in self?.errorEmit() }
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
        for row in viewModel.model.lockType.value.pads {
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
                .map { _ in pad }
                .bind(to: viewModel.input.padTap)
                .disposed(by: disposeBag)
            
            rowStackView.addArrangedSubview(padView)
            self.padViews.append(padView)
        }
        
        return rowStackView
    }
    
    private func setLockType(type: LockType) {
        titleLabel.text = type.title
        subtitleLabel.text = type.subtitle
        
    }
    
    private func setPasswordView(passwordCount: Int) {
        switch passwordCount {
        case 0:
            passwordStackView.arrangedSubviews.forEach {
                $0.backgroundColor = .code5
            }
        case 1...3:
            passwordStackView.arrangedSubviews[0...passwordCount].forEach {
                $0.backgroundColor = .code2
            }
            
            passwordStackView.arrangedSubviews[passwordCount...3].forEach {
                $0.backgroundColor = .code5
            }
        case 4:
            passwordStackView.arrangedSubviews.forEach {
                $0.backgroundColor = .code2
            }
        default: break
        }
    }
    
    private func errorEmit() {
        setErrorTitle()
        shakeAnimation()
    }
    
    private func setErrorTitle() {
        subtitleLabel.text = LockType.normal.invalidText
        subtitleLabel.textColor = .error
    }
    
    private func shakeAnimation(shouldVibrate: Bool = true, completion: (() -> ())? = nil) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.5
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        
        [titleLabel,
         subtitleLabel,
         passwordStackView].forEach {
            $0.layer.add(animation, forKey: "shake")
        }
        
        if shouldVibrate {
            self.vibrate()
        }
        
        completion?()
    }
    
    public func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType = .error) {
        vibrator.notificationOccurred(type)
    }
    
    private func padPanGesture(pan: UIPanGestureRecognizer) {
        let location = pan.location(in: self)
//        print(padWrapperStackView.frame.contains(location))
//        padViews[1].convert(padWrapperStackView, to: self)
//        print(location)
//        let view = padViews.first {
//            self.padWrapperStackView.convert($0.frame, to: self).contains(location)
//            self.convert($0.bounds, from: padWrapperStackView).contains(location)
//        }
        
        
        
//        view?.setBackgroundColor(isSelect: true)
        
//        print(convert(padViews[1].frame, from: padWrapperStackView.arrangedSubviews[0]))
//        print(convert(padViews[1].frame, to: padWrapperStackView).contains(location))
//        print(convert(padViews[1].frame, from: self).contains(location))
    }
}



