//
//  MoreViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class MoreViewController: UIViewController {
    var moreView: MoreView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let moreLineView = MoreView()
        
        moreLineView.delegate = self
        
        self.moreView = moreLineView
        self.view = moreLineView
    }
    
    override func viewDidLoad() {
        print(#function)
        configureNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: true)
    }
}

private extension MoreViewController {
    func configureNavigationButton() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftItem = makeLeftItem()
        
        navigationItem.leftBarButtonItem = leftItem
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setTitle(I18N.more, for: .normal)
        leftButton.setTitleColor(.code2, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 22)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
}
