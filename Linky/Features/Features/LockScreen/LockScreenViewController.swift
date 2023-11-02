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

public final class LockScreenViewController: PortraitViewController {
    var lockScreenView: LockScreenView!
    
    let type: LockType!
    let viewModel = LockScreenViewModel()
    public let auth = BiometricsAuthManager()
    let disposeBag = DisposeBag()
    
    var unlockAction: ((Bool) -> ())? = nil
    
    public init(type: LockType) {
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        viewModel.model.lockType.accept(type)
        let lockScreenView = LockScreenView(viewModel: viewModel)
        
        self.lockScreenView = lockScreenView
        self.view = lockScreenView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setBiometricsAuth()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
    }
    
    private func setBiometricsAuth() {
        if type == .normal && UserDefaultsManager.shared.useBiometricsAuth {
            auth.delegate = self
            auth.execute()
        }
    }
    
    private func bind() {
        viewModel.output?.didUnlock
            .drive { [weak self] in
                self?.unlockAction?($0)
                self?.dismiss(animated: true) }
            .disposed(by: disposeBag)
        
        viewModel.output?.checkBiometricsAuth
            .drive { [weak self] _ in self?.auth.execute() }
            .disposed(by: disposeBag)
    }
    
    deinit { print(description, "deinit") }
}

extension LockScreenViewController: AuthenticateStateDelegate {
    public func didUpdateState(_ state: Core.BiometricsAuthManager.AuthenticationState) {
        switch state {
        case .loggedIn:
            unlockAction?(true)
            dismiss(animated: true)
        case .fail(let error):
            print(error)
        }
    }
}
