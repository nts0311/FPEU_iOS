//
//  GetUserLocationListResponse.swift
//  FPEU
//
//  Created by son on 24/10/2022.
//

import Foundation

struct GetUserLocationListResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var locations: [FPAddress] = []
}
