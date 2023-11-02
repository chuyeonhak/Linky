//
//  AddLinkDetailView + CollectionView.swift
//  Features
//
//  Created by chuchu on 2023/06/05.
//

import UIKit
import Core

extension AddLinkDetailView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard selectedItems.indices ~= indexPath.row else { return }
        
        selectedItems[indexPath.row] = !selectedItems[indexPath.row]
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

extension AddLinkDetailView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        UserDefaultsManager.shared.tagList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.identifier,
            for: indexPath) as? TagCell,
              case let tagList = UserDefaultsManager.shared.tagList,
              let tag = tagList[safe: indexPath.row],
              let isSelected = selectedItems[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.configure(tagData: tag, isSelected: isSelected)
        
        cell.deleteButton.rx.tap
            .withUnretainedOnly(self)
            .map { $0.getIndexPath(title: tag.title) }
            .bind(to: viewModel.input.deleteIndexPath)
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    private func getIndexPath(title: String?) -> IndexPath {
        let tagList = UserDefaultsManager.shared.tagList
        guard let firstIndex = tagList.firstIndex(where: { $0.title == title })
        else { return IndexPath(item: 0, section: 0) }
        
        return IndexPath(item: firstIndex, section: 0)
    }
}

extension AddLinkDetailView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tagList = UserDefaultsManager.shared.tagList
        let text = tagList[safe: indexPath.row]?.title ?? ""
        let itemWidth = getItemWidth(text: text)
        
        return CGSize(width: itemWidth, height: 29)
    }
    
    func getItemWidth(text: String) -> CGFloat {
        let font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
        let itemSize = text.size(withAttributes: [.font: font])
        let inset: CGFloat = 15.0
        let buttonWidth: CGFloat = 20.0
        
        return round(itemSize.width) + inset + buttonWidth //
    }
}
