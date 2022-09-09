//
//  MerchantItem.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation

struct MerchantItem: Codable {
    var id: Int?
    var name: String?
    var imageUrl: String?
    var address: FPAddress?
}
