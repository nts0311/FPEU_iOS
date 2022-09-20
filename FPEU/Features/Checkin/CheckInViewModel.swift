//
//  CheckInViewModel.swift
//  FPEU
//
//  Created by son on 20/09/2022.
//

import Foundation

class CheckinViewModel: FPViewModel {
    
    let cart = UserRepo.shared.cart
    
    var orderedItem: [ProductCartItem] {
        get {
            return UserRepo.shared.cart.orderedProducts
        }
    }
    
    func getSelectedAddress() -> FPAddress? {
        return UserRepo.shared.currentUserAddress
    }
    
    func changeNumOf(product: ProductCartItem, newNum: Int) {
        cart.changeNum(of: product.product, newNum: newNum)
    }
}
