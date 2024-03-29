//
//  TagManageViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/14.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

public final class TagManageViewController: UIViewController {
    var tagManageView: TagManageView!
    let disposeBag = DisposeBag()
    let viewModel = TagManageViewModel()
    var tagList = UserDefaultsManager.shared.tagList
    
    public override func loadView() {
        let tagManageView = TagManageView(viewModel: viewModel)
        
        self.tagManageView = tagManageView
        self.view = tagManageView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkTagList()
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
    }
    
    private func configureNavigationButton() {
        let editItem = makeRightItem(tagType: .edit)
        let deleteItem = makeRightItem(tagType: .delete)
        
        
        navigationItem.rightBarButtonItems = [deleteItem, editItem]
    }
    
    private func bind() {
        tagManageView.addTagButton.rx.tap
            .bind { [weak self] in self?.openTagController(type: .add) }
            .disposed(by: disposeBag)
        
        viewModel.output?.tagHandle
            .drive { [weak self] in self?.tagHandle($0) }
            .disposed(by: disposeBag)
        
        viewModel.output?.tagSelectedCount
            .drive { [weak self] in self?.setNavigationItem(selectedCount: $0) }
            .disposed(by: disposeBag)
    }
    
    private func checkTagList() {
        let tagList = UserDefaultsManager.shared.tagList
        let selectedItems = Array(repeating: false, count: tagList.count)
        let text = I18N.tagCountText.replace(of: "COUNT", with: String(tagList.count))
        
        self.tagList = tagList
        
        tagManageView.selectedItems = selectedItems
        tagManageView.titleLabel.text = text
        tagManageView.tagTableView.reloadData()
        setNavigationItem(selectedCount: 0)
    }
    
    private func tagHandle(_ handle: TagManageViewModel.TagHandle) {
        switch handle.type {
        case .delete:
            openAlert(handle: handle)
            
        case .edit where tagList.indices ~= handle.row:
            openTagController(type: .edit, tagData: tagList[handle.row])
        default: break
        }
    }
    
    private func openAlert(handle: TagManageViewModel.TagHandle) {
        guard let tag = UserDefaultsManager.shared.tagList[safe: handle.row]
        else { return }
        
        let title = I18N.deleteTagTitle.replace(of: "TAG", with: "\"\(tag.title)\"")
        let message = I18N.deleteTagMessage
        presentAlertController(
            title: title,
            message: message,
            options: (title: I18N.cancel, style: .default), (title: I18N.delete, style: .destructive)) {
                if $0 == I18N.delete {
                    self.deleteTag(handle: handle)
                }
            }
    }
    
    private func deleteTag(handle: TagManageViewModel.TagHandle) {
        var tagList = UserDefaultsManager.shared.tagList
        let tag = tagList[safe: handle.row]
        tagManageView.selectedItems.remove(at: handle.row)
        tagList.remove(at: handle.row)
        UserDefaultsManager.shared.tagList = tagList
        let text = I18N.tagCountText.replace(of: "COUNT", with: String(tagList.count))

        tagManageView.tagTableView.deleteRows(at: [IndexPath(item: handle.row, section: 0)],
                                              with: .automatic)

        UserDefaultsManager.shared.deleteTagInLink(tag: tag)
        
        tagManageView.titleLabel.text = text
        setNavigationItem(selectedCount: 0)
    }
    
    private func setNavigationItem(selectedCount: Int) {
        let deleteButton = navigationItem.rightBarButtonItems?.first?.customView as? UIButton,
            editButton = navigationItem.rightBarButtonItems?.last?.customView as? UIButton
        
        switch selectedCount {
        case 0:
            editButton?.setImage(TagManageType.edit.offImage, for: .normal)
            deleteButton?.setImage(TagManageType.delete.offImage, for: .normal)
        case 1:
            editButton?.setImage(TagManageType.edit.onImage, for: .normal)
            deleteButton?.setImage(TagManageType.delete.onImage, for: .normal)
        default:
            editButton?.setImage(TagManageType.edit.offImage, for: .normal)
            deleteButton?.setImage(TagManageType.delete.onImage, for: .normal)
        }
    }
    
    private func makeRightItem(tagType: TagManageType) -> UIBarButtonItem {
        let rightButton = UIButton()
        
        rightButton.setImage(tagType.offImage, for: .normal)
        
        rightButton.rx.tap
            .bind { [weak self] in self?.buttonAction(type: tagType) }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func buttonAction(type: TagManageType) {
        let selectedItemCount = tagManageView.selectedItems.filter({ $0 }).count
        switch type {
        case .edit where selectedItemCount == 1:
            guard let firstIndex = tagManageView.selectedItems.firstIndex(where: { $0 })
            else { return }
            
            tagHandle((.edit, firstIndex))
        case .delete where selectedItemCount > 0:
            let tagList = UserDefaultsManager.shared.tagList,
                selectedItems = tagManageView.selectedItems
            let titleList = zip(tagList, selectedItems)
                .filter ({ $0.1 })
                .map { "\"\($0.0.title)\"" }
                .joined(separator: ", ")
            
            let title = selectedItems.filter { $0 }.count == 1 ? titleList: "[\(titleList)]"
            
            presentAlertController(
                title: I18N.deleteTagTitle.replace(of: "TAG", with: "\(title)"),
                message: I18N.deleteTagMessage,
                options: (title: I18N.cancel, style: .default), (title: I18N.delete, style: .destructive)) {
                    if $0 == I18N.delete {
                        selectedItems.enumerated().reversed().forEach { index, isSelected in
                            if isSelected {
                                self.deleteTag(handle: (type: .delete, row: index))
                            }
                        }
                    }
                }
            
        default: break
        }
        
    }
    
    func openTagController(type: TagManageType, tagData: TagData? = nil) {
        let vc = TagControlViewController(type: type, tagData: tagData)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

