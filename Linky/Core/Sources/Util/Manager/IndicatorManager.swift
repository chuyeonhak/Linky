//
//  IndicatorManager.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit

import SnapKit

public final class IndicatorManager {
    public static let shared = IndicatorManager()
    private var indicatorView: UIActivityIndicatorView?
    
    private func setIndicatorView() {
        let indicatorView = UIActivityIndicatorView()
        
        indicatorView.style = .large
        
        self.indicatorView = indicatorView
        UIApplication.shared.window?.rootViewController?.view.addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func startAnimation() {
        setIndicatorView()
        indicatorView?.startAnimating()
    }
    
    public func stopAnimation() {
        indicatorView?.stopAnimating()
        indicatorView?.removeFromSuperview()
    }
}
