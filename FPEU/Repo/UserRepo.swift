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
    
    public var currentUserAddress: FPAddress? = nil
}
