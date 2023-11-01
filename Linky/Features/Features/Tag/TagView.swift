//
//  TagView.swift
//  Features
//
//  Created by chuchu on 2023/05/31.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TagView: UIView {
    let emptyView = EmptyView(tabType: .tag)
    let viewModel: TagViewModel!
    
    var baseDataSource = UserDefaultsManager.shared.tagList
    
    lazy var tagCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .code7
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(TagGroupCell.self,
                                forCellWithReuseIdentifier: TagGroupCell.identifier)
        
        return collectionView
    }()
    
    init(viewModel: TagViewModel) {
        self.viewModel = viewModel
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
        backgroundColor = .code7
        [emptyView, tagCollectionView].forEach(addSubview)
    }
    
    private func setConstraints() {
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        tagCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() { }
}

