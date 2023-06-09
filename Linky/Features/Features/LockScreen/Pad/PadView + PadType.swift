//
//  PadView + PadType.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit
import LocalAuthentication

import Core

extension PadView {
    enum PadType: Equatable {
        case number(Int)
        case cancle
        case biometricsAuth
        case back
        
        var title: String? {
            switch self {
            case .number(let number): return String(number)
            case .cancle: return "취소"
            default: return nil
            }
        }
        
        var image: UIImage? {
            switch self {
            case .biometricsAuth: return getBiometricsImage()
            case .back: return UIImage(named: "icoCancle")
            default: return nil
            }
        }
        
        private func getBiometricsImage() -> UIImage? {
            let type = BiometricsAuthManager.biometricType()
            let color: UIColor = .code2 ?? .white
            switch type {
            case .faceID: return UIImage(systemName: "faceid")?.withTintColor(color)
            case .touchID: return UIImage(systemName: "touchid")?.withTintColor(color)
            default: return nil
            }
        }
    }
}


