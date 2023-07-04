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
}
