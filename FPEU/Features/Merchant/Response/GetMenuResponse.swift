//
//  GetMenuResponse.swift
//  FPEU
//
//  Created by son on 14/09/2022.
//

import Foundation

struct GetMenuResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var menus: [MerchantMenu] = []
}
