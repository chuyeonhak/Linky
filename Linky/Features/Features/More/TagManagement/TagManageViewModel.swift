//
//  TagManageViewModel.swift
//  Features
//
//  Created by chuchu on 2023/06/19.
//

import Core

import RxSwift
import RxRelay
import RxCocoa

final class TagManageViewModel {
    typealias TagHandle = (type: TagManageType, row: Int)
    struct Input {
        let tagHandle = PublishSubject<TagHandle>()
        let tagSelectedCount = PublishSubject<Int>()
    }
    
    struct Model { }
    
    struct Output {
        let tagHandle: Driver<TagHandle>
        let tagSelectedCount: Driver<Int>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    var tempPassword = ""
    
    init() {
        self.output = Output(
            tagHandle: input.tagHandle.asDriverOnErrorEmpty(),
            tagSelectedCount: input.tagSelectedCount.asDriverOnErrorEmpty()
        )
    }
}
