//
//  TagViewController.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

class TagViewController: UIViewController {
    var tagView: TagView!
    let disposeBag = DisposeBag()

    override func loadView() {
        let tagView = TagView()
        
        self.tagView = tagView
        self.view = tagView
    }
    
    override func viewDidLoad() {
        configureNavigationButton()
    }
}

private extension TagViewController {
    func configureNavigationButton() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftItem = makeLeftItem()
        let rightItem = makeRightItem()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setImage(UIImage(named: "icoLogo"), for: .normal)
        leftButton.setTitle(" LINKY", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
        leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 6)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    @objc func leftTapped() {
        print("wow")
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(UIImage(named: "icoArrowBottom"), for: .normal)
        rightButton.setTitle("전체", for: .normal)
        rightButton.setTitleColor(.code4, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        rightButton.semanticContentAttribute = .forceRightToLeft
        
        rightButton.rx.tap
            .bind { print("rightButtonTapped") }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
}
