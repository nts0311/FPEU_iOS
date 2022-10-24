//
//  LocationListViewModel.swift
//  FPEU
//
//  Created by son on 24/10/2022.
//

import Foundation
import RxSwift

class LocationListViewModel: FPViewModel {
    
    var locations: [FPAddress] = []
    
    
    func getListLocation() -> Single<[FPAddress]> {
        return FPNetwork.singleGet(GetUserLocationListResponse.self, endpoint: Endpoint.locationList, params: nil)
            .map { $0?.locations ?? [] }
            .do(onSuccess: {
                self.locations = $0
            })
    }
    
    func setAddress(index: Int) {
        UserRepo.shared.currentUserAddress = locations[index]
    }
    
}
