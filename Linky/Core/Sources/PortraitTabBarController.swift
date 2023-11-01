//
//  PortraitNavigationViewController.swift
//  Core
//
//  Created by chuchu on 2023/08/01.
//

import UIKit

open class PortraitNavigationViewController: UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

open class PortraitTabBarController: UITabBarController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        selectedIndex == 2 ? .portrait: .all
    }
}
