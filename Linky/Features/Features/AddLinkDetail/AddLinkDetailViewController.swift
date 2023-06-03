//
//  AddLinkDetailViewContrller.swift
//  Features
//
//  Created by chuchu on 2023/06/03.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkDetailViewContrller: UIViewController {
    var addLinkDetailView: AddLinkDetailView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let addLinkDetailView = AddLinkDetailView()
        
        self.addLinkDetailView = addLinkDetailView
        self.view = addLinkDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = "링크 추가"
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setImage(UIImage(named: "icoLogo"), for: .normal)
        leftButton.setTitle(" LINKY", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.main, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        
//        rightButton.rx.tap
        
        return UIBarButtonItem(customView: rightButton)
    }

    
    private func openAddLink() {
//        let addLinkViewController = AddLinkViewController()
//
//        let tabBar = tabBarController as? RootViewController
//
//        tabBar?.tabBarAnimation(shouldShow: false)
//
//        navigationController?.pushViewController(addLinkViewController, animated: true)
    }
}

