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
    let disposeBag = DisposeBag()
    
    let emptyView = EmptyView(tabType: .timeline)
    
    lazy var linkCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let deviceSize = UIScreen.main.bounds.size
        flowLayout.itemSize = CGSize(width: deviceSize.width, height: 88)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .code8
        collectionView.register(LinkManageCell.self,
                                forCellWithReuseIdentifier: LinkManageCell.identifier)
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        [emptyView, linkCollectionView].forEach(addSubview)
    }
    
    private func setConstraints() {
        linkCollectionView.isHidden = true
        
        emptyView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        linkCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
    }
}
