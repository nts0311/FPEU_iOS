//
//  GetHomeBannerResponse.swift
//  FPEU
//
//  Created by son on 12/09/2022.
//

import Foundation

struct GetHomeBannerResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var banners: [HomeBanner]?
}
