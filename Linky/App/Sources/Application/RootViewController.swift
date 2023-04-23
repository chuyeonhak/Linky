//
//  RootViewController.swift
//  App
//
//  Created by chuchu on 2023/04/21.
//  Copyright © 2023 chuchu. All rights reserved.
//

import UIKit

final class RootViewController: UITabBarController {
    override func viewDidLoad() {
        let testVC1 = TestViewController()
        let testVC2 = TestViewController()
        testVC2.view.backgroundColor = .red
        self.viewControllers = [testVC1, testVC2]
        
        self.setViewControllers(viewControllers, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.selectedIndex = 1
        }
    }
}
