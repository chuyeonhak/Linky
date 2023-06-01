//
//  RippleView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import SnapKit
import Then
import RxSwift

final class RippleView: UIView {
    private var rippleLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first,
              case let point = touch.location(in: self) else { return }
        
        setLayer(startPoint: point)
        startRippleAnimation()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        rippleLayer.removeFromSuperlayer()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(#function)
    }
    
    private func setLayer(startPoint: CGPoint) {
        let rippleLayer = CALayer().then {
            $0.frame = CGRectMake(startPoint.x, startPoint.y, 10, 10)
            $0.cornerRadius = 5
            $0.backgroundColor = UIColor.gray.cgColor
            $0.opacity = 0.5
            $0.masksToBounds = true
        }
        
        self.rippleLayer = rippleLayer
        
        layer.insertSublayer(rippleLayer, at: 0)
    }
    
    private func startRippleAnimation() {
        let scaleValue = UIScreen.main.bounds.width / 5
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = scaleValue
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.toValue = 1

        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation, opacityAnimation]
        groupAnimation.duration = animation.duration
        groupAnimation.timingFunction = animation.timingFunction
        groupAnimation.isRemovedOnCompletion = false

        rippleLayer.add(animation, forKey: "rippleAnimation")
    }
}

