//
//  OrderInfo.swift
//  FPEU
//
//  Created by son on 27/09/2022.
//

import Foundation

struct OrderEstimatedRouteInfo: Decodable {
    var durationInSec: Int
    var distanceInMeter: Int
    var distanceReadable: String
}

struct OrderPaymentInfo: Decodable {
    var price: Double
    var deliveryFee: Double
    var serviceFee: Double
    var discount: Double
    
    func toPaymentDetail() -> PaymentDetail {
        return PaymentDetail(price: price, deliveryFee: deliveryFee, serviceFee: serviceFee, discounts: discount)
    }
}

struct OrderedItem: Decodable {
    var name: String
    var num: Int
    var attributes: [String]
}

struct OrderInfo: Decodable {
    var orderId: Int
    var orderStatus: String
    var createdDate: String
    var fromAddress: FPAddress
    var toAddress: FPAddress
    var routeInfo: OrderEstimatedRouteInfo
    var item: [OrderedItem]
    var paymentInfo: OrderPaymentInfo
    var merchantName: String
    var driverName: String?
    var driverPhone: String?
    var driverPlate: String?
}

enum OrderStatus: String {
    case searchingDriver = "SEARCHING_DRIVER"
    case preparing = "PREPARING"
    case pickingUp = "PICKING_UP"
    case delivering = "DELIVERING"
    case succeed = "SUCCEED"
    case canceled = "CANCELED"
}
