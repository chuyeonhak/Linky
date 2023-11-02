//
//  TagViewModel.swift
//  Features
//
//  Created by chuchu on 2023/07/13.
//

import Core

import RxSwift
import RxRelay
import RxCocoa

final class TagViewModel {
    struct Input {
        let tagTapped = PublishSubject<TagData?>()
    }
    
    struct Model { }
    
    struct Output {
        let tagData: Driver<TagData?>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            tagData: input.tagTapped.asDriverOnErrorEmpty()
        )
    }
}
