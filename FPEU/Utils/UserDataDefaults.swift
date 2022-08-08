//
//  UserDataDefaults.swift
//  FPEU
//
//  Created by son on 08/08/2022.
//

import Foundation

public final class UserDataDefaults {
    public static let shared = UserDataDefaults()
    
    private let userStandard = UserDefaults.standard
    
    private let jwtTokenKey = "jwtTokenKey"
    
    public var jwtToken: String? {
        get {
            return userStandard.object(forKey: jwtTokenKey) as? String
        }
        
        set(token) {
            userStandard.set(token, forKey: jwtTokenKey)
            userStandard.synchronize()
        }
    }
}
