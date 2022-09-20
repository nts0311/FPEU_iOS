//
//  CartDetailViewModel.swift
//  FPEU
//
//  Created by son on 19/09/2022.
//

import Foundation

class CartDetailViewModel: FPViewModel {
    
    let cart = UserRepo.shared.cart
    
    var orderedItem: [ProductCartItem] {
        get {
            return UserRepo.shared.cart.orderedProducts
        }
    }
    
    func getNumOfItemInCart() -> Int {
        return cart.getNumItem()
    }
    
    func getTotalPrice() -> String {
        return String(cart.getTotalPrice()).formatAmount.safeString
    }
    
    func changeNumOf(product: ProductCartItem, newNum: Int) {
        cart.changeNum(of: product.product, newNum: newNum)
    }
    
    func clearCart() {
        cart.clearCart()
    }
    
}
