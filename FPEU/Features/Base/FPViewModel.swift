//
//  FPViewModel.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation
import RxSwift
import RxRelay

class FPViewModel {
    public let disposeBag = DisposeBag()
    
    public let errorDescription = PublishRelay<String>()
    
    init() {
        
    }
}
