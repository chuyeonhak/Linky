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
    let viewModel = NotificationSettingsViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let notificationSettingsView = NotificationSettingsView(viewModel: viewModel)
        
        self.notificationSettingsView = notificationSettingsView
        self.view = notificationSettingsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotification()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
        
        checkAllowNotfication()
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(
              self,
              selector: #selector(applicationWillEnterForeground(_:)),
              name: UIApplication.willEnterForegroundNotification,
              object: nil)

    }
    
    private func bind() {
        viewModel.output?.openAlert
            .drive { [weak self] _ in self?.openAlert() }
            .disposed(by: disposeBag)
        
        viewModel.output?.toastMessage
            .drive { UIApplication.shared.makeToast($0) }
            .disposed(by: disposeBag)
    }
    
    private func checkAllowNotfication() {
        let notiAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: notiAuthOptions) { [weak self] isAllowed, error in
                DispatchQueue.main.async {
                    UserDefaultsManager.shared.isAllowedNotification = isAllowed
                    
                    let view = self?.notificationSettingsView
                    let canUseNoti = UserDefaultsManager.shared.useNotification && isAllowed
                    let alpha: CGFloat = canUseNoti ? 1.0: 0.0
                    
                    view?.notificationSwitch.isOn = canUseNoti
                    view?.settingView.alpha = alpha
                }
        }
    }
    
    private func openAlert() {
        guard !UserDefaultsManager.shared.isAllowedNotification else { return }
        
        let title = "알림 설정에서 링키를 허용해주세요."
        let message = "확인을 누르면 설정 앱으로 이동합니다."
        
        presentAlertController(
            title: title,
            message: message,
            options: (title: "취소", style: .default), (title: "확인", style: .default)) {
                if $0 == "확인" { self.openLinkySetting() }
                if $0 == "취소" { self.cancleSetting() }
            }
    }
    
    private func openLinkySetting() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    private func cancleSetting() {
        notificationSettingsView.notificationSwitch.setOn(false, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(description, "deinit")
    }
}

extension NotificationSettingsViewController {
    @objc
    func applicationWillEnterForeground(_ notification: NSNotification) {
        checkAllowNotfication()
    }
}
