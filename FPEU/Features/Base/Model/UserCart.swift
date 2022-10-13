//
//  UserCart.swift
//  FPEU
//
//  Created by son on 17/09/2022.
//

import Foundation

class ProductCartItem: Equatable, Codable {

    @CodableIgnored
    var product: MerchantProduct!
    var num: Int = 0
    //AttrId: [OptionIds]
    var optionSelections: [Int:[Int]] = [:]
    
    static func == (lhs: ProductCartItem, rhs: ProductCartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
    
    init(product: MerchantProduct, num: Int, optionSelection: [Int:[Int]]) {
        self.product = product
        self.num = num
        self.optionSelections = optionSelection
    }
    
    func incItem() {
        num += 1
    }
    
    func descItem() {
        num -= 1
    }
    
    func calculatePrice() -> Double {
        var productPrice = product.getPrice()
        
        for (attrId, optionIds) in optionSelections {
            let attr = product.getAttributeById(id: attrId)
            
            for optionId in optionIds {
                let option = attr?.getOptionById(id: optionId)
                productPrice += option?.getPrice() ?? 0.0
            }
        }
        
        return Double(num) * productPrice
    }
    
    func getOptionsAsString() -> String {
        var result = ""
        
        for (attrId, optionIds) in optionSelections {
            let attr = product.getAttributeById(id: attrId)
            
            for optionId in optionIds {
                let option = attr?.getOptionById(id: optionId)
                result += (option?.name ?? "") + ","
            }
        }
        
        return String(result.dropLast())
    }
    
    
    func toDict() -> [String:Any] {
        var result = [String:Any]()
        
        result["productId"] = product.id
        result["num"] = num
        
        var userProductSelection = [[String:Any]]()
        
        for (attrId, optionIds) in optionSelections {
            var dict = [String:Any]()
            dict["attributeId"] = attrId
            dict["optionsId"] = optionIds
            
            userProductSelection.append(dict)
        }
        
        result["attributeSelections"] = userProductSelection
        
        return result
    }
    
}

class UserCart {
    
    private(set) var orderedProducts: [ProductCartItem] = []
    
    func getCartItem(id: Int?) -> ProductCartItem? {
        return orderedProducts.first(where: { $0.product.id == id })
    }
    
    func isProductExsited(_ product: MerchantProduct) -> Bool {
        return orderedProducts.contains(where: { $0.product.id == product.id })
    }
    
    func addProduct(_ product: MerchantProduct, num: Int, optionSelection: [Int:[Int]]) {
        if (isProductExsited(product)) {
            if let item = getCartItem(id: product.id) {
                item.incItem()
            }
            
            return
        }
        
        orderedProducts.append(ProductCartItem(product: product, num: num, optionSelection: optionSelection))
    }
    
    func changeNum(of product: MerchantProduct, newNum: Int) {
        if (!isProductExsited(product)) {
            return
        }
        
        if let productItem = getCartItem(id: product.id) {
            productItem.num = newNum
        }
    }
    
    func isCartEmpty() -> Bool {
        orderedProducts.isEmpty
    }
    
    func getNumItem() -> Int {
        orderedProducts.count
    }
    
    func getTotalPrice() -> Double {
        var result = 0.0
        
        for product in orderedProducts {
            result += product.calculatePrice()
        }
    
        return result
    }
    
    func clearCart() {
        self.orderedProducts.removeAll()
    }
    
}
