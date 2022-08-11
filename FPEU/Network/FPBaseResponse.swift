//
//  FPBaseResponse.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

struct FPBaseResponse: Decodable {
    var httpStatus: Int?
    var code: Int?
    var msg: String?
}
