//
//  InquiryViewModel.swift
//  Features
//
//  Created by chuchu on 11/13/23.
//

import Foundation

import Core

import RxSwift
import RxRelay
import RxCocoa

struct InquiryViewModel {
    struct Input {
        let categoryType = PublishSubject<CategoryType>()
        let inquiryDetails = PublishSubject<String>()
        let submitButtonTap = PublishSubject<Void>()
        let submitInquiry = PublishSubject<Void>()
    }
    
    struct Model {
        let canSubmit = BehaviorRelay<Bool>(value: false)
        let currentCategory = BehaviorRelay<CategoryType>(value: .none)
        let toastMessage = PublishSubject<String?>()
        let openSubmitAlert = PublishSubject<Void>()
        let dismissAction = PublishSubject<Void>()
    }
    
    struct Output {
        let canSubmit: Driver<Bool>
        let currentCategory: Driver<CategoryType>
        let toastMessage: Driver<String?>
        let openSubmitAlert: Driver<Void>
        let dismiss: Driver<Void>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        modelBind()
        
        self.output = Output(
            canSubmit: model.canSubmit.asDriver(),
            currentCategory: model.currentCategory.asDriver(),
            toastMessage: model.toastMessage.asDriverOnErrorEmpty(),
            openSubmitAlert: model.openSubmitAlert.asDriverOnErrorEmpty(),
            dismiss: model.dismissAction.asDriverOnErrorEmpty()
        )
    }
    
    private func modelBind() {
        Observable.combineLatest(model.currentCategory, input.inquiryDetails)
            .map { type, details in type != .none && !details.isEmpty }
            .bind(to: model.canSubmit)
            .disposed(by: disposeBag)
        
        input.submitButtonTap
            .bind(onNext: checkLimit)
            .disposed(by: disposeBag)
        
        input.categoryType
            .bind(to: model.currentCategory)
            .disposed(by: disposeBag)
        
        input.submitInquiry
            .withLatestFrom(input.inquiryDetails)
            .bind(onNext: submitInquiry)
            .disposed(by: disposeBag)
    }
    
    private func checkLimit() {
        guard UserDefaultsManager.shared.limitInquiryDic[Date().toInt()] ?? 0 < 10
        else {
            model.toastMessage.onNext(I18N.maxCountInquiryToast)
            return
        }
        
        guard model.canSubmit.value else {
            model.toastMessage.onNext(I18N.inquiryContentToast)
            return
        }
        
        model.openSubmitAlert.onNext(())
    }
    
    private func submitInquiry(text: String) {
        IndicatorManager.shared.startAnimation()
        let messageModel = SlackMessageModel()
            .addBlock(blockType: .header("\(model.currentCategory.value.type)"))
            .addBlock(blockType: .osType)
            .addBlock(blockType: .contents(text))
            .addBlock(blockType: .divider)
        
        NetworkManager.shared.request(api: getApi(messageModel: messageModel)) { data in
            IndicatorManager.shared.stopAnimation()
            switch data.result {
            case .success(_):
                UserDefaultsManager.shared.todayCountUp()
                self.model.toastMessage.onNext(I18N.submitCompleted)
                self.model.dismissAction.onNext(())
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getApi(messageModel: SlackMessageModel) -> NetworkManager.API {
        switch model.currentCategory.value {
        case .error: return .error(messageModel)
        case .etc: return .etc(messageModel)
        case .want: return .want(messageModel)
        default: return .error(messageModel)
        }
    }
}

extension InquiryViewModel {
    enum CategoryType {
        case none
        case error
        case want
        case etc
        
        var title: String {
            switch self {
            case .none: I18N.categoryNone
            case .error: I18N.categoryError
            case .want: I18N.categoryWant
            case .etc: I18N.categoryEtc
            }
        }
        
        var type: String {
            switch self {
            case .none: return ""
            case .error: return "에러"
            case .want: return "건의"
            case .etc: return "기타"
            }
        }
    }
}
