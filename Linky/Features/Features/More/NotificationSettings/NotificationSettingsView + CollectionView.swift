//
//  NotificationSettingsView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/07/18.
//

import UIKit

import Core

extension NotificationSettingsView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        notiSetting.info[indexPath.row].selected = !notiSetting.info[indexPath.row].selected
        UIView.performWithoutAnimation {
            self.dayCollectionView.reloadItems(at: [indexPath])
        }
        
        HapticManager.shared.selection()
        viewModel.input.changeNotiOption.onNext(notiSetting)
    }
}

extension NotificationSettingsView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        notiSetting.info.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayCell.identifier,
            for: indexPath) as? DayCell,
              let info = notiSetting.info[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(days: info.days, isSelected: info.selected)
        
        return cell
    }
}
