//
//  LockSetting.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

extension LockView {
    enum LockSetting {
        case changePassword
        case biometricsAuth
        
        var title: String {
            switch self {
            case .changePassword: return I18N.changePassword
            case .biometricsAuth: return I18N.useBiometrics
            }
        }
        
        var hasLine: Bool {
            switch self {
            case .changePassword: return true
            case .biometricsAuth: return false
            }
        }
    }
}
