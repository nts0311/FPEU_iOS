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
    
    let inLoad = PublishRelay<Void>()
    
    let outApiResult = PublishRelay<Void>()
    
    var estimatedRouteInfo: OrderEstimatedRouteInfo?
    var paymentInfo: OrderPaymentInfo?
    
    func getSelectedAddress() -> FPAddress? {
        return UserRepo.shared.currentUserAddress
    }
    
    func changeNumOf(product: ProductCartItem, newNum: Int) {
        cart.changeNum(of: product.product, newNum: newNum)
    }
    
    override init() {
        super.init()
    
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
    
    
    func placeOrder() {
        
    }
    
}
