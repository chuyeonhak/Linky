//
//  LockScreenViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class LockScreenViewController: UIViewController {
    var lockScreenView: LockScreenView!
    
    let type: LockType!
    let disposeBag = DisposeBag()
    
    init(type: LockType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let lockScreenView = LockScreenView(type: type)
        
        self.lockScreenView = lockScreenView
        self.view = lockScreenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
    }
    
    deinit { print(description, "deinit") }
}


