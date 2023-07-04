//
//  UIApplication +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

public extension UIApplication {
    static var safeAreaInset: UIEdgeInsets = .zero
    
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }
}
