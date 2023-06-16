//
//  AddTagViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/16.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddTagViewController: UIViewController {
    var addTagView: AddTagView!
    let disposeBag = DisposeBag()
    let type: TagManageType!
    
    init(type: TagManageType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let addTagView = AddTagView(type: type)
        
        self.addTagView = addTagView
        self.view = addTagView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        
        addTagView.canComplete
            .distinctUntilChanged()
            .bind { [weak self] in self?.setRightButton(textIsEmpty: !$0) }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationButton() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.code5, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 14)
        
        rightButton.rx.tap
            .withLatestFrom(addTagView.canComplete) { $1 }
            .filter { $0 }
            .withUnretainedOnly(self)
            .bind { $0.navigationController?.popViewController(animated: true) }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func setRightButton(textIsEmpty: Bool) {
        let fontWeight: FontManager.Weight = textIsEmpty ? .medium : .semiBold
        let font = FontManager.shared.pretendard(weight: fontWeight, size: 14)
        let color: UIColor? = textIsEmpty ? .code5: .main
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.setTitleColor(color, for: .normal)
        button?.titleLabel?.font = font
    }
}

