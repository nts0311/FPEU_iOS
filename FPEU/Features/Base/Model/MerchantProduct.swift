//
//  MerchantProduct.swift
//  FPEU
//
//  Created by son on 14/09/2022.
//

import Foundation

struct MerchantProduct: Decodable {
    var id: Int?
    var name: String?
    var description: String?
    var imageUrl: String?
    var price: Double?
    var status: String?
    var categoryId: Int?
    var merchantId: Int?
    var tagId: Int?
    var attributes: [ProductAttribute]
}

struct ProductAttribute: Decodable {
    var id: Int?
    var isMultiple: Bool?
    var isRequired: Bool?
    var productId: Int?
    var name: String?
    var options: [ProductAttributeOption]
}

struct ProductAttributeOption: Decodable {
    var id: Int?
    var name: String?
    var price: Double?
    var productAttributeId: Int?
}
