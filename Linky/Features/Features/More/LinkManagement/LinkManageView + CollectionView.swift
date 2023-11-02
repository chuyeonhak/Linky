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
        cell.bottomLineView.isHidden = indexPath.row == linkList.count - 1

        return cell
    }
}

extension LinkManageView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = getItemWidth()
        
        return CGSize(width: width, height: 88)
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
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
    
    private func getItemWidth() -> CGFloat {
        var itemCount: CGFloat = 1.0
        
        let isLandscape = UIApplication.shared.isLandscape
        let isIpad = UIDevice.current.isIpad
        let spacing = (UIApplication.shared.window?.safeAreaInsets.left ?? 0) * 2
        let collectionViewWidth: CGFloat = UIScreen.main.bounds.size.width - spacing
        
        if isLandscape { itemCount *= 2 }
        if isIpad { itemCount *= 2 }
        
        let availableWidth = collectionViewWidth - (itemCount - 1)
        let itemWidth = availableWidth / itemCount
        
        return itemWidth
    }
}
