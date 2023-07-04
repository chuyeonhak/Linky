//
//  AddLinkDetailViewContrller.swift
//  Features
//
//  Created by chuchu on 2023/06/03.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class AddLinkDetailViewContrller: UIViewController {
    var addLinkDetailView: AddLinkDetailView!
    let viewModel = AddLinkDetailViewModel()
    let disposeBag = DisposeBag()
    let metaData: MetaData!
    
    init(metaData: MetaData) {
        self.metaData = metaData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let addLinkDetailView = AddLinkDetailView(viewModel: viewModel, metaData: metaData)
        
        self.addLinkDetailView = addLinkDetailView
        self.view = addLinkDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        bind()
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
        navigationController?.navigationBar.topItem?.title = "링크 추가"
    }
    
    private func bind() {
        viewModel.output?.deleteIndexPath
            .drive { [weak self] in self?.openDeleteAlert(indexPath: $0) }
            .disposed(by: disposeBag)
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(.main, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        
        rightButton.rx.tap
            .withUnretainedOnly(self)
            .bind { $0.openAddLinkComplete() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func openAddLinkComplete() {
        saveLink()
        let addLinkCompleteVc = AddLinkCompleteViewContrller()
        
        navigationController?.pushViewController(addLinkCompleteVc, animated: true)
    }
    
    private func saveLink() {
        var link = Link(url: metaData.url)
        var linkList = UserDefaultsManager.shared.linkList
        let tagList = zip(addLinkDetailView.selectedItems, UserDefaultsManager.shared.tagList)
            .filter(\.0)
            .map(\.1)
        
        link.linkMemo = addLinkDetailView.linkLineTextField.text ?? ""
        link.tagList = tagList
        link.content = metaData
        
        linkList.append(link)
        
        UserDefaultsManager.shared.linkList = linkList
        
    }
    
    private func openDeleteAlert(indexPath: IndexPath) {
        let tag = UserDefaultsManager.shared.tagList[safe: indexPath.row]
        let message = "'\(tag?.title ?? "")' 태그를 삭제할까요?"
        presentAlertController(
            title: "",
            message: message,
            options: (title: "취소", style: .default), (title: "삭제", style: .destructive)) {
                if $0 == "삭제" {
                    self.deleteTag(indexPath: indexPath)
                }
            }
    }
    
    private func deleteTag(indexPath: IndexPath) {
        var tagList = UserDefaultsManager.shared.tagList
        
        addLinkDetailView.selectedItems.remove(at: indexPath.row)
        tagList.remove(at: indexPath.row)
        UserDefaultsManager.shared.tagList = tagList
        
        addLinkDetailView.tagCollectionView.deleteItems(at: [indexPath])
        addLinkDetailView.configData(shouldScrollToBottom: false)
    }
    
    deinit {
        print(description, "deinit")
    }
}

