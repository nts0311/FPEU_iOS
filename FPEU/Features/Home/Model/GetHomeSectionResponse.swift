//
//  GetHomeSectionResponse.swift
//  FPEU
//
//  Created by son on 09/09/2022.
//

import Foundation

struct GetHomeSectionResponse: Decodable {
    var httpStatus: Int?
    var code: String?
    var msg: String?
    
    var sections: [HomeSection]
}
