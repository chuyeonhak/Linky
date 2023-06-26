//
//  LinkManageView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/06/22.
//
import UIKit

import Core

import Then

extension LinkManageView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedItems.indices ~= indexPath.row else { return }
        
        selectedItems[indexPath.row] = !selectedItems[indexPath.row]
        collectionView.reloadItems(at: [indexPath])
        
        let selectedCount = selectedItems.filter({ $0 }).count
        
        viewModel.input.linkSelectedCount.onNext(selectedCount)
    }
}

extension LinkManageView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LinkManageCell.identifier,
            for: indexPath) as? LinkManageCell,
              case let linkList = UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }),
              let link = linkList[safe: indexPath.row],
              let isSelected = selectedItems[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(link: link, isSelected: isSelected)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        UserDefaultsManager.shared.tagList.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TagManageCell.identifier,
//                                                       for: indexPath) as? TagManageCell,
//              let tagData = UserDefaultsManager.shared.tagList[safe: indexPath.row]
//        else { return UITableViewCell() }
//
//        cell.configure(data: tagData, isSelected: selectedItems[indexPath.row])
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
//    -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive,
//                                              title: "삭제") { [weak self] action, view, success in
//            self?.viewModel.input.tagHandle.onNext((.delete, indexPath.row))
//        }.then {
//            $0.backgroundColor = .error
//        }
//
//        let editAction = UIContextualAction(style: .normal,
//                                              title: "수정") { [weak self] action, view, success in
//            self?.viewModel.input.tagHandle.onNext((.edit, indexPath.row))
//        }.then {
//            $0.backgroundColor = .code4
//        }
//
//        return getSwipeActionConfig(actions: [deleteAction, editAction])
//    }
//
//    func tableView(_ tableView: UITableView,
//                   editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    private func getSwipeActionConfig(actions: [UIContextualAction]) -> UISwipeActionsConfiguration {
//        let config = UISwipeActionsConfiguration(actions: actions)
//
////        config.performsFirstActionWithFullSwipe = false
//
//        return config
//    }
}
