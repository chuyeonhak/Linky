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
    var notificationSettingsView: NotificationSettingsView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let notificationSettingsView = NotificationSettingsView()
        
        self.notificationSettingsView = notificationSettingsView
        self.view = notificationSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
    }
}
