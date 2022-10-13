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
