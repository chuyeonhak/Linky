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
        $0.setImage(UIImage(named: "icoPlus"), for: .normal)
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
            $0.centerX.equalTo(addButtonShadowView)
            $0.size.equalTo(56)
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
    
    private func addTabViews() {
        let allCase = TabType.allCases[0...2]
        allCase.forEach { type in
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
                $0.size.equalTo(24)
            }
            
            label.snp.makeConstraints {
                $0.top.equalTo(imageView.snp.bottom).offset(8)
                $0.centerX.equalToSuperview()
            }
            
            tabbarStackView.addArrangedSubview(view)
        }
    }
    
    @discardableResult
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
    
    func addCornerRadius(radius: CGFloat,
                         _ maskedCorners: CACornerMask = .allCorners) {
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
    
    func fadeInOut(_ duration: TimeInterval = 0.25,
                   startAlpha: CGFloat = 1.0,
                   completion: (()->())? = nil) {
        UIView.animate(withDuration: duration) {
            self.alpha = abs(startAlpha - 1.0)
        } completion: { _ in
            completion?()
        }
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
    
    static let naviCode1 = UIColor(named: "naviCode1")
    static let naviCode2 = UIColor(named: "naviCode2")
    static let naviCode3 = UIColor(named: "naviCode3")
    
    
    static let alphaCode1 = UIColor(named: "alphaCode1")
    static let alphaCode2 = UIColor(named: "alphaCode2")
    static let alphaCode3 = UIColor(named: "alphaCode3")
    
    static let sub = UIColor(named: "sub")
}

extension CACornerMask {
    public static var allCorners: CACornerMask {
        return [.topLeft, .topRight, .bottomLeft, .bottomRight]
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
    
    public var window: UIWindow? {
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

extension UITextField {
    func changePlaceholderTextColor(placeholderText: String, textColor: UIColor?) {
        self.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: textColor ?? UIColor()])
    }
}

extension Reactive where Base: UIView {
    var isFirstResponder: Observable<Bool> {
        return Observable
            .merge(
                methodInvoked(#selector(UIView.becomeFirstResponder)),
                methodInvoked(#selector(UIView.resignFirstResponder))
            )
            .map{ [weak view = self.base] _ in
                view?.isFirstResponder ?? false
            }
            .startWith(base.isFirstResponder)
            .distinctUntilChanged()
            .share(replay: 1)
    }
}

extension ObservableType {
    func asDriverOnErrorEmpty() -> Driver<Element> {
        return asDriver { (error) in
            return .empty()
        }
    }
    
    func withPrevious(startWith first: Element) -> Observable<(previous: Element, current: Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
    
    func withUnretainedOnly<Object: AnyObject>(_ obj: Object) -> Observable<Object> {
        return withUnretained(obj).map { $0.0 }
    }
}
