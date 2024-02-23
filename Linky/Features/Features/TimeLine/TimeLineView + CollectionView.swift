//
//  TimeLineView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/07/04.
//

import UIKit

import Core

import Toast

extension TimeLineView: UICollectionViewDelegate {
    
}

extension TimeLineView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        baseDataSource[section].values.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(UserDefaultsManager.shared.sortedLinksByDate.map({ $0.key }))
        return baseDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TimeHeaderView.identifier, for: indexPath) as? TimeHeaderView,
              kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        header.label.text = baseDataSource[safe: indexPath.section]?.key
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = UIApplication.shared.window?.bounds.width ?? 0
        return CGSize(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeLineLinkCell.identifier,
            for: indexPath) as? TimeLineLinkCell,
              let linkList = baseDataSource[safe: indexPath.section],
              let link = linkList.values.reversed()[safe: indexPath.item]
        else { return UICollectionViewCell() }
        let wrapperViewTapped = UITapGestureRecognizer()

        cell.configure(link: link)
        cell.moreButton.menu = getSettingMenu(link: link)
        cell.copyButton.rx.tap
            .bind { [weak self] in self?.copyUrl(link: link) }
            .disposed(by: cell.disposeBag)
        
        cell.wrapperView.addGestureRecognizer(wrapperViewTapped)
        
        wrapperViewTapped.rx.event
            .map { _ in link }
            .bind(to: viewModel.input.webViewLink)
            .disposed(by: cell.disposeBag)

        return cell
    }
    
    private func getSettingMenu(link: Link) -> UIMenu {
        let editAction = UIAction(title: I18N.edit,
                                  image: UIImage(named: "icoEditOn"),
                                  handler: { [weak self] _ in self?.editLink(link: link) })
        
        let deleteAction = UIAction(title: I18N.delete,
                                    image: UIImage(named: "icoTrashCanOnRed"),
                                    attributes: .destructive,
                                    handler: { [weak self] _ in self?.deleteLink(link: link) })
        
        return UIMenu(options: .displayInline,
                      children: [editAction, deleteAction])
    }
    
    private func deleteLink(link: Link) {
        guard case var copyLinkList = UserDefaultsManager.shared.linkList,
              case let filterList = baseDataSource,
              let section = filterList.firstIndex(where: { $0.values.contains(link) }),
              let item = filterList[section].values.firstIndex(of: link),
              let linkIndex = copyLinkList.firstIndex(where: { $0.no == link.no }),
              copyLinkList.indices ~= linkIndex
        else { return }
        
        copyLinkList[linkIndex].isRemoved = true
        baseDataSource[section].values.remove(at: item)
        
        UserDefaultsManager.shared.linkList = copyLinkList
        
        linkCollectionView.performBatchUpdates {
            let deleteItem = baseDataSource[section].values.count - item
            linkCollectionView.deleteItems(at: [IndexPath(item: deleteItem, section: section)])
        }
        
        linkCollectionView.isHidden = copyLinkList.filter({ !$0.isRemoved }).isEmpty
    }
    
    private func editLink(link: Link) {
        viewModel.input.editLink.onNext(link)
    }
    
    private func copyUrl(link: Link) {
        viewModel.input.toastMessage.onNext(I18N.linkCopyComplete)
        UIPasteboard.general.string = link.url
    }
}

extension TimeLineView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = getItemWidth()
        
        return CGSize(width: width, height: 151)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        let safeAreaLeft = max(safeAreaInsets.left, 16)
        let safeAreaRight = max(safeAreaInsets.right, 16)
        
        let bottom: CGFloat = (baseDataSource.count - 1) == section ? 100 : 0
        
        return UIEdgeInsets(top: 6, left: safeAreaLeft, bottom: bottom, right: safeAreaRight)
    }
    
    private func getItemWidth() -> CGFloat {
        var itemCount: CGFloat = 1.0
        
        let isLandscape = UIApplication.shared.isLandscape
        let isIpad = UIDevice.current.isIpad
        let spacing = max(UIApplication.shared.window?.safeAreaInsets.left ?? 0, 16) * 2
        let itemSpacing: CGFloat = 8.0
        let collectionViewWidth: CGFloat = UIScreen.main.bounds.size.width - spacing
        
        if isLandscape { itemCount *= 2 }
        if isIpad { itemCount *= 2 }
        
        let availableWidth = collectionViewWidth - (itemSpacing * (itemCount - 1))
        let itemWidth = availableWidth / itemCount
        
        return itemWidth
    }
}
