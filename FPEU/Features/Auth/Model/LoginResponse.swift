//
//  LoginResponse.swift
//  FPEU
//
//  Created by son on 09/08/2022.
//

import Foundation

class LoginResponse: Decodable {
    var httpStatus: Int?
    var code: Int?
    var msg: String?
    var jwtToken: String?
    var userId: Int?
}
