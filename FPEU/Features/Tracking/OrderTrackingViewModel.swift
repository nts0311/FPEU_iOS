//
//  OrderTrackingViewModel.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import Foundation
import RxSwift
import RxRelay

class OrderTrackingViewModel: FPViewModel {
    
    let messageHub = StompMessageHub.shared
    let orderStatusRelay = PublishRelay<OrderStatus>()
    
    override init() {
        super.init()
    }
    
    deinit {
        messageHub.unsubscribe(destination: Endpoint.wsOrderStatus)
    }
    
    var orderInfo: OrderInfo? {
        return OrderRepo.shared.orderInfo
    }
    
    func getOrderStatus() -> OrderStatus {
        return orderInfo?.getOrderStatus() ?? .unknown
    }
    
    func getOrderedItemList() -> [OrderedItem] {
        return orderInfo?.item ?? []
    }
    
    func getPaymentDetail() -> PaymentDetail {
        return orderInfo?.paymentInfo.toPaymentDetail() ?? PaymentDetail(price: 0, deliveryFee: 0, serviceFee: 0, discounts: 0)
    }
    
    func getOrderInfo() -> Single<OrderInfo?> {
        return OrderRepo.shared
            .getActiveOrder()
            .do(onSubscribe: {
                self.observeOrderStatus()
            })
    }
    
    func observeOrderStatus() {
        OrderRepo.shared.getOrderStatusFlow()
            .bind(to: orderStatusRelay)
            .disposed(by: disposeBag)
    }
    
}
