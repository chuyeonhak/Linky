//
//  UITextView +.swift
//  Core
//
//  Created by chuchu on 11/13/23.
//

import UIKit

import SnapKit

public extension UITextView {
    var placeholder: UILabel? {
        subviews
            .filter { $0.tag == 100 }
            .compactMap { $0 as? UILabel }.first
    }
}
