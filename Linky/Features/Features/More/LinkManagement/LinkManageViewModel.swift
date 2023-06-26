//
//  LinkManageViewModel.swift
//  Features
//
//  Created by chuchu on 2023/06/22.
//

import Foundation

import Core

import RxSwift
import RxRelay
import RxCocoa

final class LinkManageViewModel {
    struct Input {
        let linkSelectedCount = PublishSubject<Int>()
    }
    
    struct Model {
        let linkCount = PublishSubject<Int>()
        let linkList = BehaviorRelay<[Link]>(value: UserDefaultsManager.shared.linkList)
    }
    
    struct Output {
        let linkData: Driver<[Link]>
        let linkSelectedCount: Driver<Int>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            linkData: model.linkList.asDriver(),
            linkSelectedCount: input.linkSelectedCount.asDriverOnErrorEmpty()
        )
    }
}
