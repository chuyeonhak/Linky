//
//  NotificationSettingsViewModel.swift
//  Features
//
//  Created by chuchu on 2023/07/18.
//

import Core

import RxSwift
import RxRelay
import RxCocoa

final class NotificationSettingsViewModel {
    struct Input {
        let openAlert = PublishSubject<Void>()
        let changeNotiOption = PublishSubject<NotificationSetting>()
        let saveNotiSetting = PublishSubject<NotificationSetting>()
    }
    
    struct Model {
        let notiSetting = BehaviorRelay<NotificationSetting>(value: UserDefaultsManager.shared.notiSetting)
        let canSave = BehaviorRelay<Bool>(value: UserDefaultsManager.shared.notiSetting.time == nil)
        let toastMessage = PublishSubject<String?>()
    }
    
    struct Output {
        let openAlert: Driver<Void>
        let isChanged: Driver<Bool>
        let toastMessage: Driver<String?>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            openAlert: input.openAlert.asDriverOnErrorEmpty(),
            isChanged: model.canSave.asDriverOnErrorEmpty(),
            toastMessage: model.toastMessage.asDriverOnErrorEmpty()
        )
        
        input.changeNotiOption
            .map { [weak self] in self?.canSave(noti: $0) ?? true }
            .bind(to: model.canSave)
            .disposed(by: disposeBag)
        
        input.saveNotiSetting
            .bind { [weak self] in self?.saveNotification(noti: $0) }
            .disposed(by: disposeBag)
        
        model.notiSetting
            .bind { UserDefaultsManager.shared.notiSetting = $0 }
            .disposed(by: disposeBag)
    }
    
    private func canSave(noti: NotificationSetting) -> Bool {
        noti != model.notiSetting.value && noti.info.reduce(false) { $0 || $1.selected }
    }
    
    func saveNotification(noti: NotificationSetting) {
        guard model.canSave.value else {
            model.toastMessage.onNext(I18N.notificationSettingToast)
            return
        }
        
        UserNotiManager.shared.saveNoti(noti: noti) { isSuccess in
            if isSuccess {
                self.model.toastMessage.onNext(I18N.notificationSaveToast)
                self.model.canSave.accept(false)
                self.model.notiSetting.accept(noti)
            } else {
                self.model.toastMessage.onNext(I18N.networkErrorToast)
            }
        }
    }
}

