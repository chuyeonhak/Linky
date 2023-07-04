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
    
    let vibrator = UISelectionFeedbackGenerator().then {
        $0.prepare()
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
        vibrator.selectionChanged()
        
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
