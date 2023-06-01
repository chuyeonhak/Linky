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
        $0.backgroundColor = .code8
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
        selectItem(index: 0)
    }
    
    private func addComponent() {
        addSubview(wrapperView)
        
        [addButtonShadowView, containerShadowView].forEach(wrapperView.addSubview(_:))
        
        [tabbarStackView, addButton].forEach(containerShadowView.addSubview(_:))
        
        addTabViews()
        
    }
    
    private func setConstraints() {
        containerShadowView.backgroundColor = .code8
        
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
            
            imageView.tag = Tag.tabImageView
            label.tag = Tag.tabLabel
            
            label.text = type.title
            label.textColor = Const.Custom.deseleted.color
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
        let transform = isAnimation ? .identity : CGAffineTransform(rotationAngle: .pi / 4)
        
        UIView.animate(withDuration: 0.3) {
            self.addButton.transform = transform
        }
    }
    
    func selectTab(index: Int) -> Int {
        resetSelectedItem()
        selectItem(index: index)
        
        return index
    }
    
    private func getTabSubView(index: Int) -> UIView? {
        return tabbarStackView.arrangedSubviews[safe: index]
    }
    
    private func resetSelectedItem() {
        TabType.allCases.enumerated().forEach { index, type in
            let subview = getTabSubView(index: index)
            let imageView = subview?.viewWithTag(Tag.tabImageView) as? UIImageView
            let label = subview?.viewWithTag(Tag.tabLabel) as? UILabel
            
            imageView?.image = type.offImage
            label?.textColor = Const.Custom.deseleted.color
        }
    }
    
    private func selectItem(index: Int) {
        let subview = getTabSubView(index: index)
        let imageView = subview?.viewWithTag(Tag.tabImageView) as? UIImageView
        let label = subview?.viewWithTag(Tag.tabLabel) as? UILabel
        
        imageView?.image = TabType(rawValue: index)?.onImage
        label?.textColor = Const.Custom.selected.color
    }
}



extension UIView {
    func addShadow(
        offset: CGSize,
        color: UIColor = .black,
        opacity: Float = 0.5,
        blur: CGFloat = 5.0) {
            
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = blur
    }
    
    func insert(_ mask: CACornerMask) {
        layer.maskedCorners.insert(mask)
    }
    
    func addCornerRadius(radius: CGFloat,
                         _ maskedCorners: [CACornerMask] = []) {
        
        layer.cornerRadius = radius
        maskedCorners.forEach(insert)
    }
}

extension UIColor {
    static let main = UIColor(named: "main")
    static let error = UIColor(named: "error")
    static let code1 = UIColor(named: "code1")
    static let code2 = UIColor(named: "code2")
    static let code3 = UIColor(named: "code3")
    static let code4 = UIColor(named: "code4")
    static let code5 = UIColor(named: "code5")
    static let code6 = UIColor(named: "code6")
    static let code7 = UIColor(named: "code7")
    static let code8 = UIColor(named: "code8")
}

extension CACornerMask {
    public static var allCorners: [CACornerMask] {
        return [.topLeft, .topLeft, .bottomLeft, .bottomRight]
    }
    
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
    public static var safeAreaInset: UIEdgeInsets = .zero
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
