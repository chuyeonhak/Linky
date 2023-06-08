//
//  AddLinkCompleteViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkCompleteViewContrller: UIViewController {
    var addLinkCompleteView: AddLinkCompleteView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let addLinkCompleteView = AddLinkCompleteView()
        
        self.addLinkCompleteView = addLinkCompleteView
        self.view = addLinkCompleteView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        cocoaBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func cocoaBind() {
        
        addLinkCompleteView.homeButton.rx.tap
            .bind { [weak self] in self?.popToRootViewController() }
            .disposed(by: disposeBag)
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(UIImage(named: "icoXmark"), for: .normal)
        
        rightButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
            
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func popToRootViewController() {
        let rootVc = UIApplication.shared.window?.rootViewController as? RootViewController
        rootVc?.selectedIndex = 0
        rootVc?.customTabBar.selectTab(index: 0)
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    deinit { print(description, "deinit") }
}


