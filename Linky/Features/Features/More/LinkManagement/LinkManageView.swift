//
//  LinkManageView.swift
//  Features
//
//  Created by chuchu on 2023/06/21.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class LinkManageView: UIView {
    let disposeBag = DisposeBag()
    let viewModel: LinkManageViewModel!
    
    var selectedItems = Array(
        repeating: false,
        count: UserDefaultsManager.shared.linkList.filter({ $0.isRemoved }).count)
    
    var testCount = 0
    
    let titleLabel = UILabel().then {
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 22)
    }
    
    let emptyButton = UIButton().then {
        $0.addCornerRadius(radius: 6)
        $0.backgroundColor = Const.Custom.emptyOff.color
        $0.setTitle(Const.Text.emptyButtonTitle, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 13)
    }
    
    let recoveryButton = UIButton().then {
        $0.addCornerRadius(radius: 6)
        $0.backgroundColor = Const.Custom.recoveryOff.color
        $0.setTitle(Const.Text.recoveryButtonTitle, for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 13)
    }
    
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
    
    init(viewModel: LinkManageViewModel) {
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
        self.backgroundColor = .code8
        
        [titleLabel,
         emptyButton,
         recoveryButton,
         linkCollectionView].forEach(addSubview)
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(20)
        }
        
        emptyButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(titleLabel)
            $0.width.equalTo(68)
            $0.height.equalTo(36)
        }
        
        recoveryButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(emptyButton.snp.trailing).offset(6)
            $0.width.equalTo(79)
            $0.height.equalTo(emptyButton)
        }
        
        linkCollectionView.snp.makeConstraints {
            $0.top.equalTo(emptyButton.snp.bottom).offset(38)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        viewModel.output?.linkData
            .drive { [weak self] in self?.configData(linkList: $0) }
            .disposed(by: disposeBag)
        
        emptyButton.rx.tap
            .bind { [weak self] in self?.emptyList() }
            .disposed(by: disposeBag)
        
        recoveryButton.rx.tap
            .bind { [weak self] in self?.recoveryList() }
            .disposed(by: disposeBag)
    }
    
    private func configData(linkList: [Link] = UserDefaultsManager.shared.linkList) {
        let linkCount = linkList.filter { $0.isRemoved }.count
        
        titleLabel.text = "\(linkCount)개의 링크가 있어요."
        selectedItems = Array(repeating: false, count: linkCount)
        linkCollectionView.reloadData()
        
        viewModel.input.linkSelectedCount.onNext(0)
    }
    
    func buttonActivate(isSelected: Bool) {
        let customAsset = Const.Custom.self
        
        let emptyButton = isSelected ? customAsset.emptyOn: customAsset.emptyOff,
            emptyColor = emptyButton.color
        
        let recoveryButton = isSelected ? customAsset.recoveryOn: customAsset.recoveryOff,
            recoveryColor = recoveryButton.color
        
        self.emptyButton.setBackgroundWithAnimation(color: emptyColor)
        self.recoveryButton.setBackgroundWithAnimation(color: recoveryColor)
    }
    
    func emptyList() {
        guard !selectedItems.filter({ $0 }).isEmpty else { return }
        
        let removedList = UserDefaultsManager.shared.linkList.filter { $0.isRemoved }
        
        let selectedList = zip(selectedItems, removedList).enumerated().filter(\.element.0)
        let indexPathList = selectedList.map { IndexPath(row: $0.offset, section: 0) }
        
        selectedList.forEach { _, data in
            UserDefaultsManager.shared.linkList.removeAll { $0.no == data.1.no }
        }
        
        linkCollectionView.deleteItems(at: indexPathList)
        
        configData()
    }
    
    func recoveryList() {
        guard !selectedItems.filter({ $0 }).isEmpty else { return }
        
        let removedList = UserDefaultsManager.shared.linkList.filter { $0.isRemoved }
        
        let selectedList = zip(selectedItems, removedList).enumerated().filter(\.element.0)
        let indexPathList = selectedList.map { IndexPath(row: $0.offset, section: 0) }
        
        var copyList = UserDefaultsManager.shared.linkList
        
        selectedList.forEach { _, data in
            if let firstIndex = copyList.firstIndex(where: { $0.no == data.1.no }) {
                copyList[firstIndex].isRemoved = false
            }
        }
        
        UserDefaultsManager.shared.linkList = copyList
        linkCollectionView.deleteItems(at: indexPathList)
        
        configData()
    }
    
    func addTestLink() {
        let test = Link(url: "wow\(testCount)")
        testCount += 1
        UserDefaultsManager.shared.linkList.append(test)
        
        configData()
    }
    
    func linkListRemoveAll() {
        var copy = UserDefaultsManager.shared.linkList
        
        for i in 0..<copy.count {
            copy[i].isRemoved = true
        }
        
        UserDefaultsManager.shared.linkList = copy
    }
}

