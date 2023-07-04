//
//  TimeLineView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/07/04.
//

import UIKit

import Core

extension TimeLineView: UICollectionViewDelegate {
    
}

extension TimeLineView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        UserDefaultsManager.shared.linkList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: LinkManageCell.identifier,
            for: indexPath) as? LinkManageCell,
              case let linkList = UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }),
              let link = linkList[safe: indexPath.row]
        else { return UICollectionViewCell() }

        cell.configure(link: link, isSelected: true)

        return cell
    }
}
