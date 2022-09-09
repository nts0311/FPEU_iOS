//
//  GetCategoriesResponse.swift
//  FPEU
//
//  Created by son on 09/09/2022.
//

import Foundation

struct GetCategoriesResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var categories: [ProductCategory]
}
