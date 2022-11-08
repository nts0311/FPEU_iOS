//
//  CheckInViewModel.swift
//  FPEU
//
//  Created by son on 20/09/2022.
//

import Foundation
import RxSwift
import RxRelay

class CheckinViewModel: FPViewModel {
    
    let cart = UserRepo.shared.cart
    
    var orderedItem: [ProductCartItem] {
        get {
            return UserRepo.shared.cart.orderedProducts
        }
    }
    
    let inButtonPlaceOrderTapped = PublishRelay<Void>()
    let inLoad = PublishRelay<Void>()
    
    let outApiResult = PublishRelay<Void>()
    let outPlaceOrderSuccess = PublishRelay<Void>()
    
    var estimatedRouteInfo: OrderEstimatedRouteInfo?
    var paymentInfo: OrderPaymentInfo?
    
    func getSelectedAddress() -> FPAddress? {
        return UserRepo.shared.currentUserAddress
    }
    
    func changeNumOf(product: ProductCartItem, newNum: Int) {
        cart.changeNum(of: product.product, newNum: newNum)
        getOrderCheckinInfo()
    }
    
    override init() {
        super.init()
        inButtonPlaceOrderTapped.flatMapLatest { () -> Single<CreateNewOrderResponse?> in
            
            guard let address = self.getSelectedAddress() else {
                return Single.just(CreateNewOrderResponse())
            }
            
            let params: [String:Any] = [
                "addressId":  address.id,
                "userProductSelection": self.cart.orderedProducts.map({ $0.toDict() })
            ]
            
            return FPNetwork.singlePost(CreateNewOrderResponse.self, endpoint: Endpoint.createOrder, params: params)
                //.catchAndReturn(CreateNewOrderResponse())
        }
        .do(onNext: {respone in
            if respone?.code != "0"  {
                if let msg = respone?.msg, msg.isNotEmpty {
                    self.errorDescription.accept(msg )
                }
            }
        })
        .filter {
            $0?.code == successCode && $0?.orderId != nil
        }
        .asObservable()
        .mapToVoid()
        .bind(to: outPlaceOrderSuccess)
        .disposed(by: disposeBag)
       
    }
    
    func getOrderCheckinInfo() {
        
        guard let address = self.getSelectedAddress().dict else {
            return
        }
        
        let params: [String:Any] = [
            "euAddress":  address,
            "userProductSelection": self.cart.orderedProducts.map({ $0.toDict() })
        ]
        
        FPNetwork.singlePost(endpoint: Endpoint.orderCheckinInfo, params: params)
            .subscribe(onSuccess: { (response: GetOrderCheckinInfo?) in
                guard response?.code == "0" else {
                    return
                }
                
                self.estimatedRouteInfo = response?.estimatedRouteInfo
                self.paymentInfo = response?.paymentInfo
                self.outApiResult.accept(())
            })
            .disposed(by: disposeBag)
    }
    
}
