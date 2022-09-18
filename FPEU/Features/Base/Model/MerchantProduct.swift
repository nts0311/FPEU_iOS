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
    
    func getPrice() -> Double {
        return price ?? 0.0
    }
    
    func getAttributeById(id: Int) -> ProductAttribute? {
        return attributes.first { $0.id == id }
    }
}

struct ProductAttribute: Decodable {
    var id: Int?
    var multiple: Bool?
    var required: Bool?
    var productId: Int?
    var name: String?
    var options: [ProductAttributeOption]
    
    var isRequired: Bool {
        get { return required ?? false }
    }
    
    var isMultiple: Bool {
        get { return multiple ?? false }
    }
    
    func getOptionById(id: Int) -> ProductAttributeOption? {
        return options.first { $0.id == id }
    }
}

struct ProductAttributeOption: Decodable {
    var id: Int?
    var name: String?
    var price: Double?
    var productAttributeId: Int?
    
    func getPrice() -> Double {
        return price ?? 0.0
    }
}
