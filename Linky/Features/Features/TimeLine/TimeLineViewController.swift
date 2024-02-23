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
import SwiftUI

final class TimeLineViewController: UIViewController {
    var timeLineView: TimeLineView!
    var viewModel = TimeLineViewModel()
    var currentSortType: LinkSortType = .all
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let timeLineView = TimeLineView(viewModel: viewModel)
        
        self.timeLineView = timeLineView
        self.view = timeLineView
    }
    
    override func viewDidLoad() {
        configureNavigationButton()
        bind()
        addNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
        sortList(type: currentSortType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        timeLineView.linkCollectionView.collectionViewLayout.invalidateLayout()
        setSemanticContent()
    }
    
    private func bind() {
        viewModel.output?.editLink
            .drive { [weak self] in self?.openLinkDetailView(link: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.openWebView
            .drive { [weak self] in self?.openWebView(link: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.toastMessage
            .drive { UIApplication.shared.makeToast($0) }
            .disposed(by: disposeBag)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(
              self,
              selector: #selector(applicationWillEnterForeground(_:)),
              name: UIApplication.willEnterForegroundNotification,
              object: nil)
    }
}

private extension TimeLineViewController {
    func configureNavigationButton() {
        let leftItem = makeLeftItem()
        let rightItem = makeRightItem()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setImage(UIImage(named: "icoLogo"), for: .normal)
        leftButton.setTitle(" LINKY ", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
        
        leftButton.rx.tap
            .bind { [weak self] _ in self?.openFigetViewController() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton().then {
            $0.setTitle(I18N.all, for: .normal)
            $0.setImage(UIImage(named: "icoArrowBottom"), for: .normal)
            $0.setTitleColor(.code3, for: .normal)
            $0.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
            $0.showsMenuAsPrimaryAction = true
        }
        
        let children = [UIAction(title: I18N.all,
                                 handler: { [weak self] _ in self?.sortList(type: .all) }),
                        UIAction(title: I18N.read,
                                 image: UIImage(named: "icoEyeOn"),
                                 handler: { [weak self] _ in self?.sortList(type: .read) }),
                        UIAction(title: I18N.unread,
                                 image: UIImage(named: "icoEyeOff"),
                                 handler: { [weak self] _ in self?.sortList(type: .notRead) })]
        
        rightButton.menu = UIMenu(options: .displayInline, children: children)
        
        return UIBarButtonItem(customView: rightButton)
        
    }
    
    private func makeBackButton(title: String?) -> UIBarButtonItem {
        let backButtonItem = UIBarButtonItem(
            title: title,
            style: .plain,
            target: nil,
            action: nil)
        
        backButtonItem.setTitleTextAttributes(
            [.font: FontManager.shared.pretendard(weight: .semiBold, size: 18)],
            for: .normal)
        
        return backButtonItem
    }
    
    private func checkLinkList(baseDatasource: [(key: String, values: [Core.Link])] = UserDefaultsManager.shared.sortedLinksByDate) {
        timeLineView.baseDataSource = baseDatasource
        timeLineView.linkCollectionView.isHidden = baseDatasource.isEmpty
        timeLineView.linkCollectionView.reloadData()
        timeLineView.linkCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func sortList(type: LinkSortType = .all) {
        let linkList = UserDefaultsManager.shared.sortedLinksByDate
        currentSortType = type
        
        var baseDataSource: [(key: String, values: [Core.Link])] {
            switch type {
            case .all: return linkList
            case .read: 
                return linkList.compactMap {
                    let readList = $0.values.filter { link in link.isWrittenCount != 0 }
                    return readList.isEmpty ? nil: (key: $0.key, values: readList)
                }
            case .notRead:
                return linkList.compactMap {
                    let unreadList = $0.values.filter { link in link.isWrittenCount == 0 }
                    return unreadList.isEmpty ? nil: (key: $0.key, values: unreadList)
                }
            }
        }
        
        checkLinkList(baseDatasource: baseDataSource)
        changeAssets(type: type)
    }
    
    private func changeAssets(type: LinkSortType) {
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.setTitle(type.text, for: .normal)
        button?.sizeToFit()
    }
    
    private func openLinkDetailView(link: Core.Link) {
        guard let metaData = link.content else { return }
        
        let vc = AddLinkDetailViewContrller(metaData: metaData, link: link)
        
        navigationItem.backBarButtonItem = makeBackButton(title: I18N.editLink)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setSemanticContent() {
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.semanticContentAttribute = .forceRightToLeft
    }
    
    private func openWebView(link: Core.Link) {
        guard let urlString = link.content?.url,
              let url = URL(string: urlString) else { return }
        
        let webViewController = MainWebViewController(linkUrl: url)
        
        upWrittenCount(link: link)
        navigationItem.backBarButtonItem = makeBackButton(title: I18N.back)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func upWrittenCount(link: Core.Link) {
        guard case var copyLinkList = UserDefaultsManager.shared.linkList,
              let firstIndex = copyLinkList.firstIndex(of: link),
              copyLinkList.indices ~= firstIndex,
              var copyLink = copyLinkList[safe: firstIndex]
        else { return }
        
        copyLink.isWrittenCount += 1
        
        copyLinkList[firstIndex] = copyLink
        
        UserDefaultsManager.shared.linkList = copyLinkList
    }
    
    private func openFigetViewController() {
        let vc = UIHostingController(rootView: MakerProfileView())
        vc.view.backgroundColor = .code7
        
        present(vc, animated: true)
    }
    
    @objc
    func applicationWillEnterForeground(_ notification: NSNotification) {
        sortList(type: currentSortType)
    }
}
