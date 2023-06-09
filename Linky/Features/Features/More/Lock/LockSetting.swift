//
//  LockSetting.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

extension LockView {
    enum LockSetting {
        case changePassword
        case biometricsAuth
        
        var title: String {
            switch self {
            case .changePassword: return "비밀번호 변경"
            case .biometricsAuth: return "생체인증 사용"
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
