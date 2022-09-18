//
//  UserCart.swift
//  FPEU
//
//  Created by son on 17/09/2022.
//

import Foundation

class ProductCartItem: Equatable {
    static func == (lhs: ProductCartItem, rhs: ProductCartItem) -> Bool {
        return lhs.product.id == rhs.product.id
    }
    
    init(product: MerchantProduct, num: Int, optionSelection: [Int:[Int]]) {
        self.product = product
        self.num = num
        self.optionSelection = optionSelection
    }
    
    var product: MerchantProduct!
    var num: Int = 0
    //AttrId: [OptionIds]
    var optionSelection: [Int:[Int]] = [:]
    
    func incItem() {
        num += 1
    }
    
    func descItem() {
        num -= 1
    }
}

class UserCart {
    private var products: [ProductCartItem] = []
    
    func getCartItem(id: Int?) -> ProductCartItem? {
        return products.first(where: { $0.product.id == id })
    }
    
    func isProductExsited(_ product: MerchantProduct) -> Bool {
        return products.contains(where: { $0.product.id == product.id })
    }
    
    func addProduct(_ product: MerchantProduct, num: Int, optionSelection: [Int:[Int]]) {
        if (isProductExsited(product)) {
            if let item = getCartItem(id: product.id) {
                item.incItem()
            }
            
            return
        }
        
        products.append(ProductCartItem(product: product, num: num, optionSelection: optionSelection))
    }
    
    func descProductNum(_ product: MerchantProduct) {
        if (!isProductExsited(product)) {
            return
        }
        
        if let productItem = getCartItem(id: product.id) {
            productItem.descItem()
        }
    }
    
    func isCartEmpty() -> Bool {
        products.isEmpty
    }
    
    func getNumItem() -> Int {
        products.count
    }
    
    func getTotalPrice() -> Double {
        var result = 0.0
        
        for product in products {
            var productResult = 0.0
            productResult += product.product.getPrice()
            
            for (attrId, optionIds) in product.optionSelection {
                let attr = product.product.getAttributeById(id: attrId)
                
                for optionId in optionIds {
                    let option = attr?.getOptionById(id: optionId)
                    productResult += option?.getPrice() ?? 0.0
                }
            }
            
            result += productResult * Double(product.num)
        }
    
        return result
    }
    
}
