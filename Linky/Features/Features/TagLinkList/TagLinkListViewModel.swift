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
        let webViewLink = PublishSubject<Link>()
        let toastMessage = PublishSubject<String?>()
    }
    
    struct Model { }
    
    struct Output {
        let openEditLink: Driver<Link>
        let openWebView: Driver<Link>
        let toastMessage: Driver<String?>
    }
    
    let disposeBag = DisposeBag()
    
    let model = Model()
    let input = Input()
    var output: Output?
    
    init() {
        self.output = Output(
            openEditLink: input.editLink.asDriverOnErrorEmpty(),
            openWebView: input.webViewLink.asDriverOnErrorEmpty(),
            toastMessage: input.toastMessage.asDriverOnErrorEmpty()
        )
    }
}
