//
//  FPAddress.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation
import CoreLocation

class FPAddress: Codable {
    var id: Int?
    var ward: String?
    var district: String?
    var city: String?
    var detail: String?
    var lat: Double?
    var long: Double?
    
    init(placemark: CLPlacemark) {
        self.ward = placemark.subAdministrativeArea
        self.district = placemark.administrativeArea
        self.city = placemark.locality
        self.detail = "\(placemark.name ?? ""), \(placemark.subLocality ?? "")"
        self.lat = placemark.location?.coordinate.latitude
        self.long = placemark.location?.coordinate.longitude
    }
    
    func toString() -> String {
        return "\(detail ?? ""), \(ward ?? ""), \(city ?? "")"
    }
}


