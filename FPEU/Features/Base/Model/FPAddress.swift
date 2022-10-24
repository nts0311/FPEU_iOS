//
//  FPAddress.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation
import CoreLocation
import GoogleMaps

class FPAddress: Codable {
    var id: Int?
    var ward: String?
    var district: String?
    var city: String?
    var detail: String?
    var lat: Double?
    var lng: Double?
    var name: String?
    
    init(ward: String? = nil, district: String? = nil, city: String? = nil, detail: String? = nil, lat: Double? = nil, lng: Double? = nil) {
        self.ward = ward
        self.district = district
        self.city = city
        self.detail = detail
        self.lat = lat
        self.lng = lng
    }
    
    init(placemark: CLPlacemark) {
        self.ward = placemark.subAdministrativeArea
        self.district = placemark.administrativeArea
        self.city = placemark.locality
        self.detail = "\(placemark.name ?? ""), \(placemark.subLocality ?? "")"
        self.lat = placemark.location?.coordinate.latitude
        self.lng = placemark.location?.coordinate.longitude
    }
    
    init(address: GMSAddress) {
        self.ward = address.subLocality
        self.district = nil
        self.city = address.administrativeArea
        self.detail = address.thoroughfare
        self.lat = address.coordinate.latitude
        self.lng = address.coordinate.longitude
    }
    
    func toString() -> String {
        var result = ""
        
        if let detail = detail {
            result += detail + ", "
        }
        
        if let ward = ward {
            result += ward + ", "
        }
        
        if let district = district {
            result += district + ", "
        }
        
        if let city = city {
            result += city
        }
        
        return result
    }
}


