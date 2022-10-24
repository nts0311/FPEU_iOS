//
//  UserRepo.swift
//  FPEU
//
//  Created by son on 09/09/2022.
//

import Foundation

class UserRepo {
    public static let shared = UserRepo()
    
    private init() { }
    
    public var currentUserAddress: FPAddress? = nil {
        didSet {
            didSetCurrentAddress()
        }
    }
    
    public var cart = UserCart()
    
    func didSetCurrentAddress() {
        NotificationCenter.default.post(name: .changeCurrentAddress, object: nil, userInfo: nil)
    }
}
