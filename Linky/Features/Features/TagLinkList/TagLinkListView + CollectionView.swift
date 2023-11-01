//
//  TagLinkListView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/07/13.
//

import UIKit

import Core

extension TagLinkListView: UICollectionViewDelegate {
    
}

extension TagLinkListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        linkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeLineLinkCell.identifier,
            for: indexPath) as? TimeLineLinkCell,
              let link = linkList[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(link: link)
        cell.moreButton.menu = getSettingMenu(link: link)
        
        return cell
    }
}

extension TagLinkListView {
    private func getSettingMenu(link: Link) -> UIMenu {
        let editAction = UIAction(title: "수정",
                                  image: UIImage(named: "icoEditOn"),
                                  handler: { [weak self] _ in self?.editLink(link: link) })
        
        let deleteAction = UIAction(title: "삭제",
                                    image: UIImage(named: "icoTrashCanOnRed"),
                                    attributes: .destructive,
                                    handler: { [weak self] _ in self?.deleteLink(link: link) })
        
        return UIMenu(options: .displayInline,
                      children: [editAction, deleteAction])
    }
    
    private func deleteLink(link: Link) {
        guard case var copyLinkList = UserDefaultsManager.shared.linkList,
              case let filterList = linkList,
              let filterIndex = filterList?.firstIndex(where: { $0.no == link.no }),
              let linkIndex = copyLinkList.firstIndex(where: { $0.no == link.no }),
              copyLinkList.indices ~= linkIndex
        else { return }
        
        copyLinkList[linkIndex].isRemoved = true
        linkList.remove(at: filterIndex)
        
        UserDefaultsManager.shared.linkList = copyLinkList
        
        linkCollectionView.performBatchUpdates {
            linkCollectionView.deleteItems(at: [IndexPath(item: filterIndex, section: 0)])
        }
        
    }
    
    private func editLink(link: Link) {
        viewModel.input.editLink.onNext(link)
    }
}
