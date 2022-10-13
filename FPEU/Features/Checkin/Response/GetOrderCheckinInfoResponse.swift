//
//  GetOrderCheckinInfoResponse.swift
//  FPEU
//
//  Created by son on 27/09/2022.
//

import Foundation


struct GetOrderCheckinInfo: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var estimatedRouteInfo: OrderEstimatedRouteInfo?
    var paymentInfo: OrderPaymentInfo?
}
