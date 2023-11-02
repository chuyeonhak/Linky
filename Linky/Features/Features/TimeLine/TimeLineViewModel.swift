//
//  TimeLineViewModel.swift
//  Features
//
//  Created by chuchu on 2023/07/12.
//

import Foundation

import Core

import RxSwift
import RxRelay
import RxCocoa

final class TimeLineViewModel {
    struct Input {
        let editLink = PublishSubject<Link>()
        let webViewLink = PublishSubject<Link>()
        let toastMessage = PublishSubject<String?>()
    }
    
    struct Model { }
    
    struct Output {
        let editLink: Driver<Link>
        let openWebView: Driver<Link>
        let toastMessage: Driver<String?>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            editLink: input.editLink.asDriverOnErrorEmpty(),
            openWebView: input.webViewLink.asDriverOnErrorEmpty(),
            toastMessage: input.toastMessage.asDriverOnErrorEmpty()
        )
    }
}
