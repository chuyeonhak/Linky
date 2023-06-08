//
//  MoreViewController + Delegate.swift
//  Features
//
//  Created by chuchu on 2023/06/07.
//

import UIKit

import Core

extension MoreViewController: SettingViewDelegate {
    func openNavigation(type: SettingType) {
        let vc = getViewController(type: type)
        let backButtonItem = makeBackButton(type: type)
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: false)
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func getViewController(type: SettingType) -> UIViewController {
        switch type {
        case .notificationSettings: return NotificationSettingsViewController()
        case .tips: return TipViewController()
        case .lock: return UIViewController()
        case .tagManagement: return UIViewController()
        case .linkManagement: return UIViewController()
        case .synchronizationGuide: return UIViewController()
        }
    }
    
    private func makeBackButton(type: SettingType) -> UIBarButtonItem {
        let backButtonItem = UIBarButtonItem(
            title: type.title,
            style: .plain,
            target: nil,
            action: nil)
        
        backButtonItem.setTitleTextAttributes(
            [.font: FontManager.shared.pretendard(weight: .semiBold, size: 18)],
            for: .normal)
        
        return backButtonItem
    }
}
