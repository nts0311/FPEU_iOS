//
//  GPSUtils.swift
//  FPEU
//
//  Created by son on 15/09/2022.
//

import Foundation
import CoreLocation

class GPSUtils {
    
    public static func calculateDistance(address1: FPAddress?, address2: FPAddress?) -> Double? {
        guard let address1 = address1, let address2 = address2,
              let lat1 = address1.lat, let long1 = address1.lng,
              let lat2 = address2.lat, let long2 = address2.lng else {
            return nil
        }

        return calculateDistance(fromLat: lat1, fromLong: long1, toLat: lat2, toLong: long2)
    }
    
    public static func calculateDistance(fromLat: Double, fromLong: Double, toLat:Double, toLong:Double) -> Double {
        let myLocation = CLLocation(latitude: fromLat, longitude: fromLong)
        let other = CLLocation(latitude: toLat, longitude: toLong)
        return myLocation.distance(from: other) / 1000
    }
}
