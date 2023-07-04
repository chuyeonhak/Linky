//
//  AddLinkDetailViewModel.swift
//  Features
//
//  Created by chuchu on 2023/06/28.
//

import Foundation

import Core

import RxSwift
import RxRelay
import RxCocoa

final class AddLinkDetailViewModel {
    struct Input {
        let deleteIndexPath = PublishSubject<IndexPath>()
    }
    
    struct Model { }
    
    struct Output {
        let deleteIndexPath: Driver<IndexPath>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            deleteIndexPath: input.deleteIndexPath.asDriverOnErrorEmpty()
        )
    }
}

