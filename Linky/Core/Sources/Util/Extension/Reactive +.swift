//
//  Reactive +.swift
//  CoreInterface
//
//  Created by chuchu on 2023/04/26.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    func asDriverOnErrorEmpty() -> Driver<Element> {
        return asDriver { (error) in
            return .empty()
        }
    }
    
    func withPrevious(startWith first: Element) -> Observable<(previous: Element, current: Element)> {
        return scan((first, first)) { ($0.1, $1) }.skip(1)
    }
    
    func withUnretainedOnly<Object: AnyObject>(_ obj: Object) -> Observable<Object> {
        return withUnretained(obj).map { $0.0 }
    }
}

