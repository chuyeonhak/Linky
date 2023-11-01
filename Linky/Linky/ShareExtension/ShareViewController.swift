//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by chuchu on 2023/06/08.
//  Copyright © 2023 com.chuchu. All rights reserved.
//

import UIKit
import Social

class ShareViewController: UIViewController {
//    let someView = AddLinkView()
    
    override func loadView() {
        super.loadView()
        
//        let some = TestFeature()
        let someView = UIView()
        someView.backgroundColor = .red
    
        
        self.view = someView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
