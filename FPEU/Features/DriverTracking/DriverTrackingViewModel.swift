//
//  DriverTrackingViewModel.swift
//  FPEU
//
//  Created by son on 28/11/2022.
//

import Foundation
import RxSwift
import RxRelay

struct DriverLocationMessage: Decodable {
    let lat: Double
    let lng: Double
}

class DriverTrackingViewModel: FPViewModel {
    
    let driverLocation = PublishRelay<DriverLocationMessage>()
    
    func getDriverLocationFlow() {
        StompMessageHub.shared.subscribe(to: Endpoint.wsDriverLocation)
            .compactMap {message in
                message.getBody()
            }
            .bind(to: driverLocation)
        
    }
    
    
}
