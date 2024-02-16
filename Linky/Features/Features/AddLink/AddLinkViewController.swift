//
//  AddLinkViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/02.
//

import UIKit
import LinkPresentation

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
        
        addLinkView.linkTextFiled.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(addLinkView.canComplete) { $1 }
            .filter { $0 }
            .bind(onNext: getOpenGraph)
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
//            .map { _ in }
            .bind(onNext: getOpenGraph)
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
    
    private func getOpenGraph(_ canComplete: Bool) {
        guard let urlString = getUrlString(),
              let url = URL(string: urlString) else {
            openAddLinkDetail(data: MetaData(url: addLinkView.linkTextFiled.text))
            return }
        
        IndicatorManager.shared.startAnimation()
        
        let metadataProvider = LPMetadataProvider()
        
        metadataProvider.startFetchingMetadata(for: url) { [weak self] data, error in
            if error != nil {
                self?.openAddLinkDetail(data: MetaData(url: urlString))
                return
            }
            
            let noImageMetaData = MetaData(url: urlString,
                                           title: data?.title,
                                           subtitle: nil,
                                           imageData: nil)
            
            guard let imageProvider = data?.imageProvider else {
                self?.openAddLinkDetail(data: noImageMetaData)
                return
            }
            
            imageProvider.loadObject(ofClass: UIImage.self) { image, error in
                if error != nil {
                    self?.openAddLinkDetail(data: noImageMetaData)
                    return
                }
                
                guard let metaImage = image as? UIImage else {
                    self?.openAddLinkDetail(data: noImageMetaData)
                    return
                }
                
                let metaData = MetaData(url: urlString,
                                        title: data?.title,
                                        imageData: metaImage.pngData())
                
                self?.openAddLinkDetail(data: metaData)
            }
        }
    }
    
    private func getUrlString() -> String? {
        guard var urlString = addLinkView.linkTextFiled.text else { return nil }
        
        if urlString.contains(".co") && !urlString.contains("http") {
            urlString = "https://" + urlString
        }
        
        return urlString
    }
    
    private func openAddLinkDetail(data: MetaData) {
        IndicatorManager.shared.stopAnimation()
        DispatchQueue.main.async {
            let detailViewContrller = AddLinkDetailViewContrller(metaData: data)
            
            self.navigationController?.pushViewController(detailViewContrller, animated: true)
        }
    }
    
    deinit { print(description, "deinit") }
}
