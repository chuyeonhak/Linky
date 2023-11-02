//
//  TagView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/07/12.
//

import UIKit

extension TagView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.tagTapped.onNext(baseDataSource[safe: indexPath.row])
    }
}

extension TagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        baseDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagGroupCell.identifier,
            for: indexPath) as? TagGroupCell,
              let tag = baseDataSource[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(tagTitle: tag.title)
        
        return cell
    }
}

extension TagView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = getItemWidth()
        
        return CGSize(width: width, height: 130)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
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
        
        return UIEdgeInsets(top: 0, left: safeAreaLeft, bottom: 100, right: safeAreaRight)
    }
    
    private func getItemWidth() -> CGFloat {
        var itemCount: CGFloat = 2.0
        
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
