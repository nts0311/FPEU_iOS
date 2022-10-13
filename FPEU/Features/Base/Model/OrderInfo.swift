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
    
    func getAttrsAsString() -> String {
        var result = ""
        
        for str in attributes {
            result += str + ", "
        }
        
        return String(result.dropLast(2))
    }
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
    var driverInfo: DriverInfo?
    
    func getOrderStatus() -> OrderStatus {
        return OrderStatus.init(rawValue: orderStatus ) ?? .unknown
    }
}

enum OrderStatus: String {
    case searchingDriver = "SEARCHING_DRIVER"
    case preparing = "PREPARING"
    case pickingUp = "PICKING_UP"
    case delivering = "DELIVERING"
    case succeed = "SUCCEED"
    case canceled = "CANCELED"
    case unknown = "UNKNOWN"
}
