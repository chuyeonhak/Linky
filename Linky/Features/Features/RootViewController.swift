//
//  Features.swift
//  Home
//
//  Created by chuchu on 2023/04/25.
//

import UIKit

import Core

import Then
import SnapKit
import RxSwift
import RxCocoa


public final class RootViewController: UITabBarController {
    let firstVc = UINavigationController(rootViewController: TimeLineViewController())
    let secondVc = UINavigationController(rootViewController: TagViewController())
    let disposeBag = DisposeBag()
    
    var customTabBar: CustomTabBar!
    public override func viewDidLoad() {
        super.viewDidLoad()
//        let hello = HomeTabbarController()
        
        setViewControllers([
            firstVc,
            secondVc,
        ], animated: false)
        self.tabBar.isHidden = true
        commonInit()
    }
    
    private func commonInit() {
        
        
    }
    
    private func setTabbar() {
        self.customTabBar = CustomTabBar()
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints {
            let bottomInset = UIApplication.safeAreaInset.bottom
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(bottomInset + 78)
        }
    }
    
    override public func viewSafeAreaInsetsDidChange() {
        setTabbar()
        customTabBar.tabbarStackView.arrangedSubviews.enumerated().forEach { index, subview in
            let tapGesture = UITapGestureRecognizer()
            
            subview.addGestureRecognizer(tapGesture)
            
            tapGesture.rx.event
                .withUnretainedOnly(self)
                .map { $0.customTabBar.selectTab(index: index) }
                .bind(to: rx.selectedIndex)
                .disposed(by: disposeBag)
        }
    }
}

final class TimelineNavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationBar.barTintColor = .red
        self.navigationBar.isTranslucent = false
        
        let cancle = UIBarButtonItem(systemItem: .cancel)
        self.navigationItem.leftBarButtonItem = cancle
        navigationItem.title = "hello"
        print(#function)
        
        
    }
}


final class TestCell: UITableViewCell {
    static let identifier = description()
    
    let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }
    
    private func addComponent() {
        contentView.addSubview(label)
    }
    
    private func setConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func bind() { }
    
    func configure(model: String) {
        label.text = model
    }
}




enum Features {
    case timeLine
    case tag
    case moreView
    case add
    
    var selectedIndex: Int {
        switch self {
        case .timeLine: return 0
        case .tag: return 1
        case .moreView: return 2
        case .add: return -1
        }
    }
}
