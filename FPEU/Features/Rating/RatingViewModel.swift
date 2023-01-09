//
//  RatingViewModel.swift
//  FPEU
//
//  Created by son on 15/12/2022.
//

import Foundation
import RxSwift
import RxRelay


class RatingViewModel: FPViewModel {
    var merchantRating: Int?
    var driverRating: Int?
    var orderId: Int! = 4437
    
    let inTappedSendButton = PublishRelay<Void>()
    
    let outApiResult = PublishRelay<Bool>()
    
    let inMerchantRating = PublishRelay<Int?>()
    let inDriverRating = PublishRelay<Int?>()
    
    let outButtonEnabled = PublishRelay<Bool>()
    
    
    override init() {
        super.init()
        Observable.combineLatest(inMerchantRating, inDriverRating)
            .do(onNext: {merchantRating, driverRating in
                print(merchantRating, driverRating)
                self.merchantRating = merchantRating
                self.driverRating = driverRating
            })
            .map {merchantRating, driverRating in
                return merchantRating != nil && driverRating != nil
            }
            .bind(to: outButtonEnabled)
            .disposed(by: disposeBag)
    }
    
    func sendRate() {
        let params = [
            "orderId": orderId,
            "merchantStar": merchantRating,
            "driverStar": driverRating
        ]
        
        FPNetwork.singlePost(endpoint: Endpoint.rate, params: params)
            .subscribe(onSuccess: { (response: FPBaseResponse?) in
                guard response?.code == "0" else {
                    return
                }
                
                self.outApiResult.accept(true)
            })
            .disposed(by: disposeBag)
    }
    
}
