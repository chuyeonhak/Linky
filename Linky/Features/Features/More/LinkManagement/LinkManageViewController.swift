//
//  LinkManageViewController.swift
//  Features
//
//  Created by chuchu on 2023/06/21.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class LinkManageViewController: UIViewController {
    var linkManageView: LinkManageView!
    let disposeBag = DisposeBag()
    let viewModel = LinkManageViewModel()
    
    override func loadView() {
        let linkManageView = LinkManageView(viewModel: viewModel)
        
        self.linkManageView = linkManageView
        self.view = linkManageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configureNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = .code8
        navigationController?.navigationBar.backgroundColor = .code8
        UIApplication.shared.windows.first?.viewWithTag(Tag.statusBar)?.backgroundColor = .code8
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        linkManageView.linkCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func bind() {
        viewModel.output?.linkSelectedCount
            .drive { [weak self] in self?.setNavigationItem(selectedCount: $0) }
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationButton() {
        let rightButton = makeRightItem()
        
        navigationItem.rightBarButtonItem = rightButton
    }
    

    private func setNavigationItem(selectedCount: Int) {
        let rightButton = navigationItem.rightBarButtonItems?.first?.customView as? UIButton
        let selectedItems = linkManageView.selectedItems
        let isSelected = selectedCount != 0
        
        switch selectedCount {
        case _ where selectedItems.isEmpty:
            rightButton?.setImage(UIImage(named: "checkOff"), for: .normal)
            rightButton?.setTitleColor(.code5, for: .normal)
        case selectedItems.count:
            rightButton?.setImage(UIImage(named: "check"), for: .normal)
            rightButton?.setTitleColor(.main, for: .normal)
        default:
            rightButton?.setImage(UIImage(named: "checkOn"), for: .normal)
            rightButton?.setTitleColor(.code3, for: .normal)
        }
        rightButton?.sizeToFit()
        
        linkManageView.buttonActivate(isSelected: isSelected)
    }
    
    private func makeRightItem() -> UIBarButtonItem {
        let rightButton = UIButton()
        
        let imageStr = linkManageView.selectedItems.isEmpty ? "checkOff": "checkOn"
        let titleColor: UIColor? = linkManageView.selectedItems.isEmpty ? .code5: .code3
        
        rightButton.setTitle(" " + I18N.selectAll, for: .normal)
        rightButton.setTitleColor(titleColor, for: .normal)
        rightButton.titleLabel?.font = FontManager.shared.pretendard(weight: .medium, size: 14)
        
        rightButton.setImage(UIImage(named: imageStr), for: .normal)
        
        rightButton.rx.tap
            .bind { [weak self] in self?.buttonAction() }
            .disposed(by: disposeBag)
        
        return UIBarButtonItem(customView: rightButton)
    }
    
    private func buttonAction() {
        guard !linkManageView.selectedItems.isEmpty,
              case let isAllSelected = linkManageView.selectedItems.filter({ !$0 }).isEmpty,
              case let isSelectedCount = isAllSelected ? 0: linkManageView.selectedItems.count
        else { return }
        
        linkManageView.selectedItems = Array(repeating: !isAllSelected,
                                             count: linkManageView.selectedItems.count)
        linkManageView.linkCollectionView.reloadData()
        setNavigationItem(selectedCount: isSelectedCount)
    }
}

