//
//  AddLinkViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkViewController: UIViewController {
    var addLinkView: AddLinkView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let addLinkView = AddLinkView()
        
        self.addLinkView = addLinkView
        self.view = addLinkView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        
        addLinkView.canComplete
            .distinctUntilChanged()
            .bind { [weak self] in self?.setRightButton(textIsEmpty: !$0) }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setPasteButton()
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        navigationController?.navigationBar.backItem?.title = ""
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
    }
    
    private func setPasteButton() {
        guard let pasteString = UIPasteboard.general.string else { return }
        
        addLinkView.pasteButton.isHidden = pasteString.isEmpty
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        let backButtonItem = makeBackButton()
        
        navigationItem.backBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = ""
        
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.code5, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 14)
        
        rightButton.rx.tap
            .withLatestFrom(addLinkView.canComplete) { $1 }
            .filter { $0 }
            .withUnretainedOnly(self)
            .bind { $0.getOpenGraph() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func makeBackButton() -> UIBarButtonItem {
        let backButtonItem = UIBarButtonItem(
            title: "링크 추가",
            style: .plain,
            target: nil,
            action: nil)
        
        backButtonItem.setTitleTextAttributes(
            [.font: FontManager.shared.pretendard(weight: .semiBold, size: 18)],
            for: .normal)
        
        return backButtonItem
    }
    
    private func setRightButton(textIsEmpty: Bool) {
        let fontWeight: FontManager.Weight = textIsEmpty ? .medium : .semiBold
        let font = FontManager.shared.pretendard(weight: fontWeight, size: 14)
        let color: UIColor? = textIsEmpty ? .code5: .main
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.setTitleColor(color, for: .normal)
        button?.titleLabel?.font = font
    }
    
    private func getOpenGraph() {
        let urlString = addLinkView.linkTextFiled.text
    
        guard let urlString else { return }
        IndicatorManager.shared.startAnimation()
        OpenGraphManager.shared.getMetaData(urlString: urlString) { data in
            IndicatorManager.shared.stopAnimation()
            self.openAddLinkDetail(data: data)
        }
    }
    
    private func openAddLinkDetail(data: MetaData) {
        DispatchQueue.main.async {
            let detailViewContrller = AddLinkDetailViewContrller(metaData: data)
            
            self.navigationController?.pushViewController(detailViewContrller, animated: true)
        }
    }
    
    deinit { print(description, "deinit") }
}
