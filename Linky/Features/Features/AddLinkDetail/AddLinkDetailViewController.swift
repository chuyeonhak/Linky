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
    var link: Link?
    
    init(metaData: MetaData, link: Link? = nil) {
        self.metaData = metaData
        self.link = link
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let addLinkDetailView = AddLinkDetailView(viewModel: viewModel,
                                                  metaData: metaData,
                                                  link: link)
        
        self.addLinkDetailView = addLinkDetailView
        self.view = addLinkDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetting()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tabBar = tabBarController as? RootViewController
        
        tabBar?.tabBarAnimation(shouldShow: false)
        addLinkDetailView.linkLineTextField.becomeFirstResponder()
    }
    
    private func navigationSetting() {
        let rightItem = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func bind() {
        viewModel.output?.deleteIndexPath
            .drive { [weak self] in self?.openDeleteAlert(indexPath: $0) }
            .disposed(by: disposeBag)
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setTitle(I18N.confirm, for: .normal)
        rightButton.setTitleColor(.main, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        
        rightButton.rx.tap
            .withUnretainedOnly(self)
            .bind { $0.openAddLinkComplete() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func openAddLinkComplete() {
        if let link {
            hasTagText()
            editLink(link: link)
            
            UIApplication.shared.makeToast(I18N.linkModiToast)
            navigationController?.popViewController(animated: true)
        } else {
            hasTagText()
            saveLink()
            UIApplication.shared.makeToast(I18N.addLinkToast)
            navigationController?.popToRootViewController(animated: true)
        }
        
        
    }
    
    private func hasTagText() {
        guard addLinkDetailView.tagLineTextField.text?.isEmpty == false else { return }
        
        addLinkDetailView.addTagList()
    }
    
    private func editLink(link: Link) {
        guard case var copyLink = link,
              case var linkList = UserDefaultsManager.shared.linkList,
              let index = UserDefaultsManager.shared.linkList.firstIndex(of: link),
              linkList.indices ~= index
        else { return }
        
        let tagList = zip(addLinkDetailView.selectedItems, UserDefaultsManager.shared.tagList)
            .filter(\.0)
            .map(\.1)
        
        copyLink.linkMemo = addLinkDetailView.linkLineTextField.text ?? ""
        copyLink.tagList = tagList
        
        linkList[index] = copyLink
        
        UserDefaultsManager.shared.linkList = linkList
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
        guard let tag = UserDefaultsManager.shared.tagList[safe: indexPath.row]
        else { return }
        let title = I18N.deleteTagTitle.replace(of: "TAG", with: "\"\(tag.title)\"")
        let message = I18N.deleteTagMessage
        presentAlertController(
            title: title,
            message: message,
            options: (title: I18N.cancel, style: .default),
            (title: I18N.delete, style: .destructive)) {
                if $0 == I18N.delete {
                    self.deleteTag(indexPath: indexPath)
                    UserDefaultsManager.shared.deleteTagInLink(tag: tag)
                }
            }
    }
    
    private func deleteTag(indexPath: IndexPath) {
        var tagList = UserDefaultsManager.shared.tagList
        
        addLinkDetailView.selectedItems.remove(at: indexPath.row)
        tagList.remove(at: indexPath.row)
        UserDefaultsManager.shared.tagList = tagList
        
        addLinkDetailView.tagCollectionView.deleteItems(at: [indexPath])
        addLinkDetailView.setCollectionViewHeight(isDeleted: true)
    }
    
    deinit {
        print(description, "deinit")
    }
}

