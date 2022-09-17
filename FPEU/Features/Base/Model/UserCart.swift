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
    
    init(product: MerchantProduct, num: Int) {
        self.product = product
        self.num = num
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
    
    func addProduct(_ product: MerchantProduct, num: Int) {
        if (isProductExsited(product)) {
            if let item = getCartItem(id: product.id) {
                item.incItem()
            }
            
            return
        }
        
        products.append(ProductCartItem(product: product, num: num))
    }
    
    func descProductNum(_ product: MerchantProduct) {
        if (!isProductExsited(product)) {
            return
        }
        
        if let productItem = getCartItem(id: product.id) {
            productItem.descItem()
        }
    }
    
}
