//
//  BiometricsAuthManager.swift
//  Core
//
//  Created by chuchu on 2023/06/08.
//

import LocalAuthentication

public class BiometricsAuthManager {
    public static func biometricType() -> LABiometryType {
        let authContext = LAContext()
        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch(authContext.biometryType) {
        case .none:
            return .none
        case .touchID:
            return .touchID
        case .faceID:
            return .faceID
        @unknown default:
            fatalError()
        }
    }
}
