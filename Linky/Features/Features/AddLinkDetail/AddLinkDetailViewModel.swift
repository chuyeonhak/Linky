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

public final class AddLinkDetailViewModel {
    public struct Input {
        public let deleteIndexPath = PublishSubject<IndexPath>()
    }
    
    struct Model { }
    
    public struct Output {
        public let deleteIndexPath: Driver<IndexPath>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    public var output: Output?
    
    public init() {
        self.output = Output(
            deleteIndexPath: input.deleteIndexPath.asDriverOnErrorEmpty()
        )
    }
}

