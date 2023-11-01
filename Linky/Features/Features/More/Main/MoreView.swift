//
//  MoreView.swift
//  Features
//
//  Created by chuchu on 2023/06/01.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

protocol SettingViewDelegate {
    func openNavigation(type: SettingType, hasLock: Bool)
}

final class MoreView: UIView {
    let disposeBag = DisposeBag()
    
    var delegate: SettingViewDelegate?
    
    let tableViewWrapperView = UIView().then {
        $0.addShadow(offset: CGSize(width: 0, height: 0), opacity: 0.08, blur: 10)
        $0.addCornerRadius(radius: 12)
        $0.backgroundColor = .code8
    }
    
    lazy var settingTableView = UITableView().then {
        $0.addCornerRadius(radius: 12)
        $0.register(MoreSettingCell.self, forCellReuseIdentifier: MoreSettingCell.identifier)
        $0.separatorStyle = .none
        $0.delegate = self
        $0.dataSource = self
        $0.rowHeight = 60
        $0.isScrollEnabled = UIDevice.current.orientation.isLandscape
    }
    
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
        addSubview(tableViewWrapperView)
        tableViewWrapperView.addSubview(settingTableView)
        configSettingViews()
    }
    
    private func setConstraints() {
        backgroundColor = .code7
        
        tableViewWrapperView.snp.makeConstraints {
            let bottomInset = UIApplication.shared.tabBarHeight
            
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.height.equalTo(SettingType.allCases.count * 60)
            $0.bottom.lessThanOrEqualToSuperview().inset(bottomInset)
        }
        
        settingTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configSettingViews() {
//        SettingType.allCases.forEach { type in
//            let settingView = MoreSettingView(),
//                settingViewTapped = UITapGestureRecognizer()
//
//            settingView.configure(type: type)
//            settingView.addGestureRecognizer(settingViewTapped)
//
//            settingViewTapped.rx.event
//                .bind { [weak self] _ in
//                    self?.delegate?.openNavigation(type: type, hasLock: true)
//                }.disposed(by: disposeBag)
//
//            settingStackView.addArrangedSubview(settingView)
//        }
    }
    
    private func bind() { }
}

extension MoreView: UITableViewDelegate {
    
}

extension MoreView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreSettingCell.identifier,
                                                       for: indexPath) as? MoreSettingCell,
              let setting = SettingType.allCases[safe: indexPath.row]
        else { return UITableViewCell() }
        
        let contentViewTapped = UITapGestureRecognizer()
        
        cell.contentView.addGestureRecognizer(contentViewTapped)
        cell.configure(type: setting)
        
        contentViewTapped.rx.event
            .bind { [weak self] _ in self?.delegate?.openNavigation(type: setting, hasLock: true) }
            .disposed(by: cell.disposeBag)
        
        return cell
    }
}
