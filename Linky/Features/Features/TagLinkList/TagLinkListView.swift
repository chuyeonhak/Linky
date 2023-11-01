//
//  TagLinkListView.swift
//  Features
//
//  Created by chuchu on 2023/07/13.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagLinkListView: UIView {
    let disposeBag = DisposeBag()

    let tagData: TagData!
    let viewModel: TagLinkListViewModel!
    var linkList: [Link]!

    lazy var linkCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .code7
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(TimeLineLinkCell.self,
                                forCellWithReuseIdentifier: TimeLineLinkCell.identifier)

        return collectionView
    }()

    init(viewModel: TagLinkListViewModel, tagData: TagData, linkList: [Link]) {
        self.viewModel = viewModel
        self.tagData = tagData
        self.linkList = linkList

        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        addComponent()
        setConstraints()
        bind()
    }

    private func addComponent() {
        addSubview(linkCollectionView)
    }

    private func setConstraints() {
        linkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bind() { }
}
