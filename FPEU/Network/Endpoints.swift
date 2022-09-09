//
//  Endpoints.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation

class Endpoint {
    public static let login = "/auth/login"
    public static let homeInfo = "/enduser/home/info"


    public static let getCategories = "/shared/productCategory/list"
    public static let getHomeSection = "/enduser/home/section"
    public static let getNearbyMerchant = "/enduser/home/nearby-merchant"
    
    public static let getUserCurrentAddress = "/enduser/info/current-address"
}

