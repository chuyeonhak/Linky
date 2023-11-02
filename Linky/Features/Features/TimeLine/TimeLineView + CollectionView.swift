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
        baseDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TimeLineLinkCell.identifier,
            for: indexPath) as? TimeLineLinkCell,
              let link = baseDataSource[safe: indexPath.row]
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
              case let filterList = baseDataSource,
              let filterIndex = filterList.firstIndex(where: { $0.no == link.no }),
              let linkIndex = copyLinkList.firstIndex(where: { $0.no == link.no }),
              copyLinkList.indices ~= linkIndex
        else { return }
        
        copyLinkList[linkIndex].isRemoved = true
        baseDataSource.remove(at: filterIndex)
        
        UserDefaultsManager.shared.linkList = copyLinkList
        
        linkCollectionView.performBatchUpdates {
            linkCollectionView.deleteItems(at: [IndexPath(item: filterIndex, section: 0)])
        }
        
    }
    
    private func editLink(link: Link) {
        viewModel.input.editLink.onNext(link)
    }
    
    private func copyUrl(link: Link) {
        viewModel.input.toastMessage.onNext("링크 복사가 완료되었습니다.")
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
        
        return UIEdgeInsets(top: 6, left: safeAreaLeft, bottom: 100, right: safeAreaRight)
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
