//
//  AddLinkDetailView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit
import Core

extension AddLinkDetailView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
//        <#code#>
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath) {
//        <#code#>
    }
}

extension AddLinkDetailView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            testArray.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: TagCell.identifier,
                    for: indexPath) as? TagCell
            else { return UICollectionViewCell() }
            
            cell.configure(model: testArray[safe: indexPath.item])
            
            return cell
    }
}

extension AddLinkDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let text = testArray[safe: indexPath.row]?.title ?? ""
            let font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
            let itemSize = text.size(withAttributes: [.font: font])
            
            return CGSize(width: round(itemSize.width) + 20, height: 29)
    }
}
