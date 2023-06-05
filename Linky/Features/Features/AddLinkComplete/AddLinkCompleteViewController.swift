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
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(UIImage(named: "icoXmark"), for: .normal)
        
        rightButton.rx.tap
            .bind { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
}


