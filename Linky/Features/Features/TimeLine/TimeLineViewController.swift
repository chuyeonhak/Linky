//
//  TimeLineViewController.swift
//  Features
//
//  Created by chuchu on 2023/05/17.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TimeLineViewController: UIViewController {
    var timeLineView: TimeLineView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let timeLineView = TimeLineView()
        
        self.timeLineView = timeLineView
        self.view = timeLineView
    }
    
    override func viewDidLoad() {
        print(#function)
        configureNavigationButton()
    }
}

private extension TimeLineViewController {
    func configureNavigationButton() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let leftItem = makeLeftItem()
        let rightItem = makeRightItem()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setImage(UIImage(named: "icoLogo"), for: .normal)
        leftButton.setTitle(" LINKY", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
//        leftButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 6)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    @objc func leftTapped() {
        print("wow")
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(UIImage(named: "icoArrowBottom"), for: .normal)
        rightButton.setTitle("전체", for: .normal)
        rightButton.setTitleColor(.code3, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        rightButton.semanticContentAttribute = .forceRightToLeft
        
        rightButton.rx.tap
            .bind { print("rightButtonTapped") }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
}
