//
//  AddLinkViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkViewController: UIViewController {
    var addLinkView: AddLinkView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let addLinkView = AddLinkView()
        
        self.addLinkView = addLinkView
        self.view = addLinkView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        
        addLinkView.canComplete
            .distinctUntilChanged()
            .bind { [weak self] in self?.setRightButton(textIsEmpty: !$0) }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let pasteString = UIPasteboard.general.string else { return }
        
        addLinkView.pasteButton.isHidden = pasteString.isEmpty
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.code5, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 14)
        
        rightButton.rx.tap
            .withLatestFrom(addLinkView.canComplete) { $1 }
            .filter { $0 }
            .withUnretainedOnly(self)
            .bind { $0.openAddLinkDetail() }
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
    
    private func openAddLinkDetail() {
        let detailViewContrller = AddLinkDetailViewContrller()
        
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: false)
        
        navigationController?.pushViewController(detailViewContrller, animated: true)
    }
}
