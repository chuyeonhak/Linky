//
//  TagViewController.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagViewController: UIViewController {
    var tagView: TagView!
    var currentTagDic: [TagData: [Link]] = [:]
    
    let viewModel = TagViewModel()
    let disposeBag = DisposeBag()
    var baseTagList: [TagData] = []

    override func loadView() {
        let tagView = TagView(viewModel: viewModel)
        
        self.tagView = tagView
        self.view = tagView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        navigationItem.searchController?.isActive = false
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code7
        checkLinkList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tagView.tagCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func checkLinkList() {
        let tagSet = getTagSet() + UserDefaultsManager.shared.noTagData
        
        tagView.baseDataSource = tagSet
        tagView.tagCollectionView.isHidden = tagSet.isEmpty
        tagView.tagCollectionView.reloadData()
        tagView.tagCollectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    func getTagSet() -> [TagData] {
        let tagDic = UserDefaultsManager.shared.getTagDic()
        
        let sortedTag = tagDic.sorted { first, second in
            let (tag1, link1) = first
            let (tag2, link2) = second
            
            return link1.count != link2.count ? link1.count > link2.count: tag1.title < tag2.title
        }.map(\.key)
        
        currentTagDic = tagDic
        baseTagList = sortedTag
        
        return sortedTag
    }
    
    private func setSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .code7
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "검색어를 입력해 주세요."
        searchController.obscuresBackgroundDuringPresentation = false 
        
        self.navigationItem.searchController = searchController
    }
}

private extension TagViewController {
    func configureNavigationButton() {
        setSearchController()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .code7
        navigationController?.navigationBar.backgroundColor = .code7
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .code7
        
        navigationItem.leftBarButtonItem = makeLeftItem()
    }
    
    private func bind() {
        viewModel.output?.tagData
            .drive { [weak self] in self?.openLinkList(tagData: $0) }
            .disposed(by: disposeBag)
        
    }
    
    private func openLinkList(tagData: TagData?) {
        guard let tagData,
              case let linkList = currentTagDic[tagData] ?? [] else { return }
        
        let vc = TagLinkListViewController(tagData: tagData, linkList: linkList)
        let backButtonItem = makeBackButton(title: tagData.title)
        
        navigationItem.backBarButtonItem = backButtonItem
        navigationController?.pushViewController(vc, animated: true)
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
    
    private func makeLeftItem() -> UIBarButtonItem {
        let leftButton = UIButton()
        
        leftButton.setTitle("태그", for: .normal)
        leftButton.setTitleColor(.code3, for: .normal)
        leftButton.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 24)
        
        leftButton.rx.tap
            .bind {
                print("wow")
            }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: leftButton)
    }
}
