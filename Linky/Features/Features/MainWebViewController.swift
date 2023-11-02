//
//  MainWebViewController.swift
//  Features
//
//  Created by chuchu on 2023/07/14.
//

import UIKit
import WebKit

import Core

import SnapKit
import Then
import RxSwift

final class MainWebViewController: UIViewController {
    let linkUrl: URL!
    
    let webView = WKWebView()
    
    init(linkUrl: URL) {
        self.linkUrl = linkUrl
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = webView
        let request = URLRequest(url: linkUrl)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: false)
    }
    
    deinit { print(description, "deinit") }
}
