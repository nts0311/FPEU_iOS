//
//  HomeInfoResponse.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation

struct GetMerchantListResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var merchants: [MerchantItem] = []
}
