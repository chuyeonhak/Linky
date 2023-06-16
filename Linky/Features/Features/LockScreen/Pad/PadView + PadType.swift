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
        case cancel
        case biometricsAuth
        case back
        
        var title: String? {
            switch self {
            case .number(let number): return String(number)
            case .cancel: return "취소"
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
            let imageString = type == .faceID ? "faceid": "touchid"
            let image = UIImage(systemName: imageString) ?? UIImage()
            
            switch type {
            case _ where !UserDefaultsManager.shared.useBiometricsAuth:
                return nil
            case .faceID:
                return image.withTintColor(color, renderingMode: .alwaysOriginal)
            case .touchID:
                return image.withTintColor(color, renderingMode: .alwaysOriginal)
            default: return nil
            }
        }
    }
}


