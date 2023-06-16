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

final class TagManageViewController: UIViewController {
    var tagManageView: TagManageView!
    let disposeBag = DisposeBag()
    
    override func loadView() {
        let tagManageView = TagManageView()
        
        self.tagManageView = tagManageView
        self.view = tagManageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationButton()
        bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            .bind { [weak self] in self?.openAddTag() }
            .disposed(by: disposeBag)
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
        switch type {
        case .edit:
            print("edit")
        case .delete:
            print("delete")
        default: break
        }
        
    }
    
    private func openAddTag() {
        let vc = AddTagViewController(type: .add)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

