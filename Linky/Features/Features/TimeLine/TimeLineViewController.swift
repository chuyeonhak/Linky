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
    var viewModel = TimeLineViewModel()
    var currentSortType: LinkSortType = .all
    let disposeBag = DisposeBag()
    var testCount = 15
    
    override func loadView() {
        let timeLineView = TimeLineView(viewModel: viewModel)
        
        self.timeLineView = timeLineView
        self.view = timeLineView
    }
    
    override func viewDidLoad() {
        configureNavigationButton()
        bind()
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
        leftButton.setTitle(" LINKY", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
        
        leftButton.rx.tap
            .bind { [weak self] _ in self?.test() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
    
    private func test() {
        guard testCount > 0 else { return }
        testCount -= 1
        
        switch testCount {
        case 5, 10:
            print("\(testCount)번 더 눌러야해요.")
        case 1:
            UserDefaultsManager.shared.linkList = []
            UserDefaultsManager.shared.tagList = []
            
            sortList(type: currentSortType)
            UIApplication.shared.makeToast("리스트 모두 초기화 완료")
        default: break
        }
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let children = [UIAction(title: "전체",
                                 handler: { [weak self] _ in self?.sortList(type: .all) }),
                        UIAction(title: "읽음",
                                 image: UIImage(named: "icoEyeOn"),
                                 handler: { [weak self] _ in self?.sortList(type: .read) }),
                        UIAction(title: "안 읽음",
                                 image: UIImage(named: "icoEyeOff"),
                                 handler: { [weak self] _ in self?.sortList(type: .notRead) })]
        
        let menu = UIMenu(options: .displayInline,
                          children: children)
        
        return UIBarButtonItem(image: UIImage(named: "icoLinkAll"), menu: menu)
        
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
    
    private func checkLinkList(baseDatasource: [Link] = UserDefaultsManager.shared.linkList.filter({ !$0.isRemoved })) {
        timeLineView.baseDataSource = baseDatasource
        timeLineView.linkCollectionView.isHidden = baseDatasource.isEmpty
        timeLineView.linkCollectionView.reloadData()
        timeLineView.linkCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func sortList(type: LinkSortType = .all) {
        let linkList = UserDefaultsManager.shared.linkList.filter({ !$0.isRemoved })
        currentSortType = type
        
        var baseDataSource: [Link] {
            switch type {
            case .all: return linkList
            case .read: return linkList.filter { $0.isWrittenCount != 0 }
            case .notRead: return linkList.filter { $0.isWrittenCount == 0 }
            }
        }
        
        checkLinkList(baseDatasource: baseDataSource.reversed())
        changeAssets(type: type)
    }
    
    private func changeAssets(type: LinkSortType) {
        let item = navigationItem.rightBarButtonItem
        var imageString: String {
            switch type {
            case .all: return "icoLinkAll"
            case .read: return "icoLinkRead"
            case .notRead: return "icoLinkNotRead"
            }
        }
        
        item?.image = UIImage(named: imageString)
    }
    
    private func openLinkDetailView(link: Link) {
        guard let metaData = link.content else { return }
        
        let vc = AddLinkDetailViewContrller(metaData: metaData, link: link)
        
        navigationItem.backBarButtonItem = makeBackButton(title: "링크 수정")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openWebView(link: Link) {
        guard let urlString = link.content?.url,
              let url = URL(string: urlString) else { return }
        
        let webViewController = MainWebViewController(linkUrl: url)
        
        upWrittenCount(link: link)
        navigationItem.backBarButtonItem = makeBackButton(title: "돌아가기")
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    private func upWrittenCount(link: Link) {
        
        guard case var copyLinkList = UserDefaultsManager.shared.linkList,
              let firstIndex = copyLinkList.firstIndex(of: link),
              copyLinkList.indices ~= firstIndex,
              var copyLink = copyLinkList[safe: firstIndex]
        else { return }
        
        copyLink.isWrittenCount += 1
        
        copyLinkList[firstIndex] = copyLink
        
        UserDefaultsManager.shared.linkList = copyLinkList
    }
}
