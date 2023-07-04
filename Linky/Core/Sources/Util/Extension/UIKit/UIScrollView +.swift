//
//  UIScrollView +.swift
//  Core
//
//  Created by chuchu on 2023/07/03.
//

import UIKit


public extension UIScrollView {
    func scrollsToBottom() {
        let y = contentSize.height - bounds.size.height + contentInset.bottom
        let bottomOffset = CGPoint(x: 0, y: y)
        
        setContentOffset(bottomOffset, animated: true)
    }
}
