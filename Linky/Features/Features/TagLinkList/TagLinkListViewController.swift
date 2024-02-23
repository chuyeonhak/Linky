//
//  TagLinkListViewController.swift
//  Features
//
//  Created by chuchu on 2023/07/13.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagLinkListViewController: UIViewController {
    var tagLinkListView: TagLinkListView!
    var currentSortType: LinkSortType = .all
    let tagData: TagData!
    var linkList: [Link]!
    let disposeBag = DisposeBag()
    let viewModel = TagLinkListViewModel()
    
    init(tagData: TagData, linkList: [Link]) {
        self.tagData = tagData
        self.linkList = linkList
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let tagLinkListView = TagLinkListView(viewModel: viewModel,
                                              tagData: tagData,
                                              linkList: linkList)
        
        self.tagLinkListView = tagLinkListView
        self.view = tagLinkListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        setSearchController()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        navigationController?.navigationBar.backItem?.title = ""
        
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
        
        checkLinkList()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setSemanticContent()
    }
}

private extension TagLinkListViewController {
    func configureNavigationButton() {
        let rightItem = makeRightItem()
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: false)
        navigationItem.rightBarButtonItem = rightItem
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
        
        rightButton.menu = UIMenu(options: .displayInline,children: children)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func makeBackButton(title: String) -> UIBarButtonItem {
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
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue(I18N.cancel, forKey: "cancelButtonText")
        searchController.searchBar.placeholder = I18N.findLinkInfoPlaceholder
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
    }
    
    private func checkLinkList(baseDataSrouce: [Link]) {
        tagLinkListView.linkList = baseDataSrouce
        tagLinkListView.linkCollectionView.reloadData()
        tagLinkListView.linkCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    private func sortList(type: LinkSortType = .all) {
        currentSortType = type
        
        print(linkList.count)
        var baseDataSource: [Link] {
            switch type {
            case .all: return linkList
            case .read: return linkList.filter { $0.isWrittenCount != 0 }
            case .notRead: return linkList.filter { $0.isWrittenCount == 0 }
            }
        }
        
        print(linkList.count)
        
        checkLinkList(baseDataSrouce: baseDataSource)
        changeAssets(type: type)
    }
    
    private func changeAssets(type: LinkSortType) {
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.setTitle(type.text, for: .normal)
        button?.sizeToFit()
    }
    
    private func setSemanticContent() {
        let button = navigationItem.rightBarButtonItem?.customView as? UIButton
        
        button?.semanticContentAttribute = .forceRightToLeft
    }
    
    private func bind() {
        viewModel.output?.openEditLink
            .drive { [weak self] in self?.openLinkDetailView(link: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.openWebView
            .drive { [weak self] in self?.openWebView(link: $0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.toastMessage
            .drive { UIApplication.shared.makeToast($0) }
            .disposed(by: disposeBag)
    }
    
    private func openLinkDetailView(link: Link) {
        guard let metaData = link.content else { return }
        let vc = AddLinkDetailViewContrller(metaData: metaData, link: link)
        
        navigationItem.backBarButtonItem = makeBackButton(title: I18N.editLink)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func openWebView(link: Link) {
        guard let urlString = link.content?.url,
              let url = URL(string: urlString) else { return }
        
        let webViewController = MainWebViewController(linkUrl: url)
        
        upWrittenCount(link: link)
        navigationItem.backBarButtonItem = makeBackButton(title: I18N.back)
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
    
    func checkLinkList() {
        let tagDic = UserDefaultsManager.shared.getTagDic()
        var linkList = tagDic[tagData] ?? []
        
        if tagData.title == I18N.noTags { linkList += UserDefaultsManager.shared.noTagLinkList }
        
        self.linkList = linkList
        tagLinkListView.linkList = linkList
        tagLinkListView.linkCollectionView.reloadData()
    }
}
