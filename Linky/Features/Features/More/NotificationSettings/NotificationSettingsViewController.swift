//
//  NotificationSettingsViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class NotificationSettingsViewController: UIViewController {
    var moreView: MoreView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let moreLineView = MoreView()
        
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
