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
    public static let updateFcmToken = "/auth/update-fcm-token"

    public static let getCategories = "/shared/productCategory/list"
    public static let getHomeSection = "/enduser/home/section"
    public static let getNearbyMerchant = "/enduser/home/nearby-merchant"
    public static let getHomeBanner = "/enduser/home/banner"
    
    public static let getUserCurrentAddress = "/enduser/info/current-address"
    
    public static let getMenus = "/merchant/menu/list"
    public static let getProducts = "/merchant/product/list"
    
    public static let orderCheckinInfo = "/enduser/order/checkin-info"
    public static let orderInfo = "/enduser/order/get-info"
    public static let createOrder = "/enduser/order/create"
    public static let rate = "/enduser/order/rate"
    
    public static let getActiveOrder = "/enduser/order/get-active-order"
    
    public static let wsOrderStatus = "/users/ws/eu/orderStatus"
    
    public static let locationList = "/enduser/info/location-list"
    public static let addLocation = "/enduser/info/add-location"
    
    public static let findMerchant = "/enduser/home/find-merchants"
    
    public static let wsDriverLocation = "/users/ws/eu/driverLocation"
}

