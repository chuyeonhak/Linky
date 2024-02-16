//
//  TimeLineView.swift
//  Features
//
//  Created by chuchu on 2023/05/17.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class TimeLineView: UIView {
    let viewModel: TimeLineViewModel!
    let disposeBag = DisposeBag()
    let emptyView = EmptyView(tabType: .timeline)
    
    var baseDataSource = UserDefaultsManager.shared.sortedLinksByDate
    
    lazy var linkCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .code7
        collectionView.register(
            TimeLineLinkCell.self,
            forCellWithReuseIdentifier: TimeLineLinkCell.identifier)
        
        collectionView.register(
            TimeHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TimeHeaderView.identifier)
        
        return collectionView
    }()
    
    init(viewModel: TimeLineViewModel) {
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
        [emptyView, linkCollectionView].forEach(addSubview)
    }
    
    private func setConstraints() {
        linkCollectionView.isHidden = true
        
        emptyView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
        
        linkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() { }
}
