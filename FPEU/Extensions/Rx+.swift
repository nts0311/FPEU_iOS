//
//  Rx+.swift
//  FPEU
//
//  Created by son on 08/09/2022.
//

import Foundation
import RxSwift
import RxCocoa


public extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver(onErrorDriveWith: Driver.empty())
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func ignoreNil<Wrapped>() -> Observable<Wrapped> where Element == Swift.Optional<Wrapped> {
        return flatMap { (element) -> Observable<Wrapped> in
            switch element {
            case .some(let value):
                return Observable.just(value)
            case .none:
                return Observable.empty()
            }
        }
    }
}

public extension ObservableConvertibleType {
    func catchErrorJustComplete() -> Observable<Element> {
        return self.asObservable().catch { _ in Observable.empty() }
    }
}

