//
//  CreateNewOrderResponse.swift
//  FPEU
//
//  Created by son on 14/10/2022.
//

import Foundation

struct CreateNewOrderResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var orderId: Int?
}
