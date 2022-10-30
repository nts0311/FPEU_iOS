//
//  OrderRepo.swift
//  FPEU
//
//  Created by son on 13/10/2022.
//

import Foundation
import RxSwift

struct GetActiveOrderResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var orderInfo: OrderInfo?
}


class OrderRepo {
    private init() {}
    static let shared = OrderRepo()
    
    var orderInfo: OrderInfo? = nil
    
        
    func getOrderStatusFlow() -> Observable<OrderStatus> {
        StompMessageHub.shared.subscribe(to: Endpoint.wsOrderStatus)
            .do(onNext: {message in
                self.processOrderStatusMessage(message: message)
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
                self.orderInfo?.orderStatus = orderStatus.rawValue
            })
            .startWith((orderInfo != nil) ? (orderInfo?.getOrderStatus() ?? .unknown) : .searchingDriver)
    }
    
    func processOrderStatusMessage(message: WSMessage) {
        switch message.getCode() {
        case .foundDriver:
            self.setDriverInfo(message: message)
        case .cancelOrder:
            let reason: String = message.getBody() ?? ""
            NotificationCenter.default.post(name: .orderCanceled, object: nil, userInfo: ["reason": reason])
        default: ()
        }
    }
    
    func setDriverInfo(message: WSMessage) {
        guard let driverInfo: DriverInfo? = message.getBody() else {
            return
        }
        
        orderInfo?.driverInfo = driverInfo
    }
    
}


//MARK: API
extension OrderRepo {
    func getActiveOrder() -> Single<OrderInfo?> {
        return FPNetwork.singleGet(endpoint: Endpoint.getActiveOrder, params: nil)
            .catchAndReturn(GetActiveOrderResponse())
            .do(onSuccess: {response in
                guard let response = response, response.code == successCode else {
                    return
                }
                
                self.orderInfo = response.orderInfo
            })
            .map {
                $0?.orderInfo
            }
    }
}
