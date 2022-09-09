//
//  HomeSection.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation

struct HomeSection: Codable {
    var name: String?
    var description: String?
    var listMerchant: [MerchantItem] = []
}
