//
//  NotificationSettingsView.swift
//  Features
//
//  Created by chuchu on 2023/06/08.
//

import UIKit

import Core

import SnapKit
import Then
import RxSwift

final class NotificationSettingsView: UIView {
    let viewModel: NotificationSettingsViewModel!
    let disposeBag = DisposeBag()
    
    var notiSetting = UserDefaultsManager.shared.notiSetting
    
    let notificationLabel = UILabel().then {
        $0.text = "알림 사용"
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 15)
    }
    
    let lineView = UIView().then {
        $0.backgroundColor = .code6
    }
    
    let settingView = UIView().then {
        let alpha = UserDefaultsManager.shared.useNotification ? 1.0: 0
        
        $0.backgroundColor = .code7
        $0.alpha = alpha
    }
    
    let notificationSwitch = UISwitch().then {
        let userDefaults = UserDefaultsManager.shared
        let isOn = userDefaults.isAllowedNotification && userDefaults.useNotification
        
        $0.onTintColor = .main
        $0.isOn = isOn
    }
    
    let setDayLabel = UILabel().then {
        $0.text = "요일 설정"
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
    }
    
    lazy var dayCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 65, height: 33)
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 6.0
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 16, bottom: 32, right: 16)
        
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: DayLeftAlignFlowLayout())
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.register(DayCell.self,
                                forCellWithReuseIdentifier: DayCell.identifier)
        
        return collectionView
    }()
    
    let setTimeLabel = UILabel().then {
        $0.text = "시간 설정"
        $0.textColor = .code2
        $0.font = FontManager.shared.pretendard(weight: .semiBold, size: 14)
    }
    
    lazy var datePicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.date = notiSetting.time ?? Date()
    }
    
    lazy var saveButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.addCornerRadius(radius: 10)
        $0.backgroundColor = .code5
        $0.titleLabel?.font = FontManager.shared.pretendard(weight: .bold, size: 15)
    }
    
    init(viewModel: NotificationSettingsViewModel) {
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
        backgroundColor = .code8
        
        [notificationLabel,
         notificationSwitch,
         lineView,
         settingView].forEach(addSubview)
        
        [setDayLabel,
         dayCollectionView,
         setTimeLabel,
         datePicker,
         saveButton].forEach(settingView.addSubview)
    }
    
    private func setConstraints() {
        notificationLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        notificationSwitch.snp.makeConstraints {
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(30)
            $0.centerY.equalTo(notificationLabel)
            $0.width.equalTo(40)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(notificationLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        settingView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        setDayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        dayCollectionView.snp.makeConstraints {
            let height = getCollectionViewHeight()
            
            $0.top.equalTo(setDayLabel.snp.bottom)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(height)
        }
        
        setTimeLabel.snp.makeConstraints {
            $0.top.equalTo(dayCollectionView.snp.bottom)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        datePicker.snp.makeConstraints {
            $0.top.equalTo(setTimeLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(150)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview().inset(30)
            $0.height.equalTo(56)
        }
    }
    
    private func bind() {
        notificationSwitch.rx.isOn
            .changed
            .bind { [weak self] in self?.checkAllowNoti(isOn: $0) }
            .disposed(by: disposeBag)
        
        datePicker.rx.date
            .changed
            .map(setNotiTime)
            .bind(to: viewModel.input.changeNotiOption)
            .disposed(by: disposeBag)
        
        viewModel.output?.isChanged
            .map { $0 ? .main: .code5 }
            .drive { [weak self] in self?.saveButton.setBackgroundWithAnimation(color: $0) }
            .disposed(by: disposeBag)
            
        saveButton.rx.tap
            .withUnretainedOnly(self)
            .map { $0.notiSetting }
            .bind(to: viewModel.input.saveNotiSetting)
            .disposed(by: disposeBag)
    }
    
    private func checkAllowNoti(isOn: Bool) {
        if !UserDefaultsManager.shared.isAllowedNotification && isOn {
            viewModel.input.openAlert.onNext(())
            return
        }
        
        let alpha: CGFloat = isOn ? 0: 1.0,
            notiManager = UserNotiManager.shared
        
        UserDefaultsManager.shared.useNotification = isOn
        settingView.fadeInOut(startAlpha: alpha)
        
        isOn ? notiManager.saveNoti(): notiManager.deleteAllNotifications()
    }
    
    private func getCollectionViewHeight() -> Int {
        let deviceSize = UIApplication.shared.window?.bounds.width ?? 0
        let maxItemWidth: CGFloat = 65 * 7
        let maxItemSpacing: CGFloat = 6 * 6
        let leftRightInset: CGFloat = 16 * 2
        
        let isExceeded = (maxItemWidth + maxItemSpacing + leftRightInset) > deviceSize
        
        return isExceeded ? 121 : 82
    }
    
    private func setNotiTime(date: Date) -> NotificationSetting {
        notiSetting.time = date
        
        return notiSetting
    }
}
