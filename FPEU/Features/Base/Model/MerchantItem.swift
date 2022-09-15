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
    
    var subTitle: String?
    var distance: Double?
    var numStar: Double?
    var numOrder: Int?
    
    func getDistance() -> String {
        return distance?.prettyDistance ?? ""
    }
}
