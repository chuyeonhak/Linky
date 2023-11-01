//
//  TagLinkListViewModel.swift
//  Features
//
//  Created by chuchu on 2023/07/14.
//

import Core

import RxSwift
import RxRelay
import RxCocoa

final class TagLinkListViewModel {
    struct Input {
        let editLink = PublishSubject<Link>()
    }
    
    struct Model { }
    
    struct Output {
        let openEditLink: Driver<Link>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            openEditLink: input.editLink.asDriverOnErrorEmpty()
        )
    }
}
