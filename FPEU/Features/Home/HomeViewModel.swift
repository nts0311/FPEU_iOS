//
//  HomeViewModel.swift
//  FPEU
//
//  Created by son on 06/09/2022.
//

import Foundation
import RxSwift
import RxRelay
import CoreLocation
import RxCoreLocation


class HomeViewModel: FPViewModel {
    let inLoadHomeInfo = PublishRelay<Void>()
    
    let outHomeInfo = PublishRelay<([ProductCategory], [HomeSection], [MerchantItem])>()
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        
        let loadCategories = inLoadHomeInfo
            .flatMapLatest {
                FPNetwork.singleGet(GetCategoriesResponse.self, endpoint: Endpoint.getCategories, params: nil)
                    .catchErrorJustComplete()
            }
            .compactMap {
                return $0?.code == "0" ? $0?.categories : nil
            }
        
        let loadSections = inLoadHomeInfo
            .flatMapLatest {
                FPNetwork.singleGet(GetHomeSectionResponse.self, endpoint: Endpoint.getHomeSection, params: nil)
                    .catchErrorJustComplete()
            }
            .compactMap {
                return $0?.code == "0" ? $0?.sections : nil
            }
            
        
        let nearbyRestaurant = inLoadHomeInfo
            .flatMapLatest {
                self.locationManager.rx.placemark.take(1)
                    .map { FPAddress(placemark: $0) }
                    .catchErrorJustComplete()
            }
            .flatMapLatest { address in
                FPNetwork.singlePost(GetUserCurrentLocationResponse.self, endpoint: Endpoint.getUserCurrentAddress, params: address.dictionary)
                    .catchErrorJustComplete()
            }
            .do(onNext: {response in
                self.saveUserCurrentLocation(response)
            })
            .compactMap {
                return $0?.code == "0" ? $0?.currentLocation : nil
            }
            .flatMapLatest { address in
                FPNetwork.singlePost(GetNearbyMerchantResponse.self, endpoint: Endpoint.getNearbyMerchant, params: ["lat" : address.lat, "long": address.long])
                    .catchErrorJustComplete()
            }
            .compactMap { $0?.nearbyRestaurant }
        
        
        Observable.combineLatest(loadCategories, loadSections, nearbyRestaurant)
            .bind(to: outHomeInfo)
            .disposed(by: disposeBag)
            
    }
    
    
    private func saveUserCurrentLocation(_ response: GetUserCurrentLocationResponse?) {
        guard let response = response, response.code == "0", let location = response.currentLocation else {
            return
        }

        UserRepo.shared.currentUserAddress = location
    }
}


//Call API
extension HomeViewModel {
    
}


