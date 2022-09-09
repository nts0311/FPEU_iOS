//
//  GetUserCurrentLocationResponse.swift
//  FPEU
//
//  Created by son on 08/09/2022.
//

import Foundation


class GetUserCurrentLocationResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var currentLocation: FPAddress?
}
