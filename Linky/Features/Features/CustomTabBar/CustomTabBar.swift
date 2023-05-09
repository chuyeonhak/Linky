//
//  CustomTabBar.swift
//  Features
//
//  Created by chuchu on 2023/05/04.
//

import UIKit

import Core

import RxSwift
import RxCocoa

final class CustomTabBar: UIView {
    let disposeBag = DisposeBag()
    
    let wrapperView = UIView().then {
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.16, blur: 10)
    }
    
    let containerShadowView = UIView().then {
        $0.addCornerRadius(radius: 16, [.topLeft, .topRight])
    }
    
    let tabbarStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }
    
    let addButtonShadowView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 34
    }
    
    let addButton = UIButton().then {
        $0.layer.cornerRadius = 34
        $0.setImage(UIImage(named: "plus"), for: .normal)
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
        addSubview(wrapperView)
        
        [addButtonShadowView, containerShadowView].forEach(wrapperView.addSubview(_:))
        
        [tabbarStackView, addButton].forEach(containerShadowView.addSubview(_:))
        
        addTabViews()
        
    }
    
    private func setConstraints() {
        containerShadowView.backgroundColor = .white
        
        wrapperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addButtonShadowView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(26)
            $0.size.equalTo(68)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(addButtonShadowView).inset(6)
            $0.width.equalTo(62)
            $0.height.equalTo(63)
            $0.centerX.equalTo(addButtonShadowView)
        }
        
        containerShadowView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.bottom.leading.trailing.equalToSuperview()
        }
        
        tabbarStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(addButtonShadowView.snp.leading).offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        addButton.rx.tap
            .withUnretainedOnly(self)
            .bind {
                let isAnimation = $0.addButton.transform != .identity
                $0.buttonAnimation(isAnimation)
            }
            .disposed(by: disposeBag)
    }
    
    private func addTabViews() {
        TabType.allCases.forEach { type in
            let view = UIView()
            let imageView = UIImageView(image: type.offImage)
            let label = UILabel()
            
            label.text = type.title
            label.textColor = .black
            label.font = FontManager.shared.pretendard(weight: .medium, size: 11)
            
            [imageView, label].forEach(view.addSubview(_:))
            
            imageView.snp.makeConstraints {
                $0.top.equalToSuperview().inset(12)
                $0.centerX.equalToSuperview()
                $0.size.equalTo(20)
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
            
            tabbarStackView.addArrangedSubview(view)
        }
    }
    
    private func buttonAnimation(_ isAnimation: Bool) {
        let transform: CGAffineTransform = isAnimation ? .identity : CGAffineTransform(rotationAngle: .pi / 4)
        
        UIView.animate(withDuration: 0.3) {
            self.addButton.transform = transform
        }
    }
}



extension UIView {
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, blur: CGFloat = 5.0) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
    }
    
    func addCornerRadius(radius: CGFloat,
                         _ maskedCorners: CACornerMask = []) {
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
}

extension CACornerMask {
    public static var topLeft: CACornerMask {
        return .layerMinXMinYCorner
    }
    
    public static var topRight: CACornerMask {
        return .layerMaxXMinYCorner
    }
    
    public static var bottomLeft: CACornerMask {
        return .layerMinXMaxYCorner
    }
    
    public static var bottomRight: CACornerMask {
        return .layerMaxXMaxYCorner
    }
}


extension UIApplication {
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .last { $0.isKeyWindow }
    }
    var safeAreaInset: UIEdgeInsets {
        window?.safeAreaInsets ?? .zero
    }
}
