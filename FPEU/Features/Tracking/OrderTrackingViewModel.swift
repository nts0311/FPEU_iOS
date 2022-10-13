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
        messageHub.subscribe(to: "/users/ws/eu/orderStatus")
        .do(onNext: {message in
            self.processWSMessage(message: message)
        })
        .map {message in
            switch WSMessageCode.init(rawValue: message.code) {
            case .foundDriver:
                return .preparing
            case .deliveringOrderToCustomer:
                return .delivering
            case .orderCompleted:
                return .succeed
            case .cancelOrder:
                return.canceled
            default:
                return .unknown
            }
        }
        .do(onNext: {orderStatus in
            OrderRepo.shared.orderInfo?.orderStatus = orderStatus.rawValue
        })
        .startWith((orderInfo != nil) ? (orderInfo?.getOrderStatus() ?? .unknown) : .searchingDriver)
        .bind(to: orderStatusRelay)
        .disposed(by: disposeBag)
    }
    
    func processWSMessage(message: WSMessage) {
        switch message.getCode() {
        case .foundDriver:
            self.setDriverInfo(message: message)
        default: ()
        }
    }
    
    func setDriverInfo(message: WSMessage) {
        guard let driverInfo: DriverInfo? = message.getBody() else {
            return
        }
        
        OrderRepo.shared.orderInfo?.driverInfo = driverInfo
    }
    
}
