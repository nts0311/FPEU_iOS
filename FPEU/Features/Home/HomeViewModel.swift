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
    
    let outHomeInfo = PublishRelay<([ProductCategory], [HomeSection], [MerchantItem], [HomeBanner])>()
    
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
                $0?.categories
            }
        
        let loadSections = inLoadHomeInfo
            .flatMapLatest {
                FPNetwork.singleGet(GetHomeSectionResponse.self, endpoint: Endpoint.getHomeSection, params: nil)
                    .catchErrorJustComplete()
            }
            .compactMap {
                $0?.sections
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
            .compactMap { $0?.currentLocation }
            .flatMapLatest { address in
                FPNetwork.singlePost(GetNearbyMerchantResponse.self, endpoint: Endpoint.getNearbyMerchant, params: ["lat" : address.lat, "long": address.long])
                    .catchErrorJustComplete()
            }
            .compactMap { $0?.merchants }
        
        let homeBanner = inLoadHomeInfo
            .flatMapLatest {
                FPNetwork.singleGet(GetHomeBannerResponse.self, endpoint: Endpoint.getHomeBanner, params: nil)
                    .catchErrorJustComplete()
            }
            .compactMap { $0?.banners }
        
        
        Observable.combineLatest(loadCategories, loadSections, nearbyRestaurant, homeBanner)
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


