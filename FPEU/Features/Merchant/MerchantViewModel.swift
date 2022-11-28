//
//  MerchantViewModel.swift
//  FPEU
//
//  Created by son on 14/09/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MerchantViewModel: FPViewModel {
    
    let inLoad = PublishRelay<Void>()
    
    let outApiResult = PublishRelay<Void>()
    
    var merchantItem: MerchantItem!
    
    var menuList: [MerchantMenu] = []
    //var products: [MerchantProduct] = []
    var sectionedProductList: [Int:[MerchantProduct]] = [:]
    
    override init() {
        super.init()
        
        let getMenu: Observable<[MerchantMenu]> = inLoad
            .flatMapLatest {
                FPNetwork.singleGet(endpoint: Endpoint.getMenus, params: ["merchantId": self.merchantItem.id as Any, "page": 0, "size": 100])
                    .catchAndReturn(GetMenuResponse())
            }
            .compactMap {
                return $0?.code == "0" ? $0?.menus : []
            }
        
        let getProduct: Observable<[MerchantProduct]> = inLoad
            .flatMapLatest {
                FPNetwork.singleGet(endpoint: Endpoint.getProducts, params: ["merchantId": self.merchantItem.id as Any, "page": 0, "size": 100])
                    .catchAndReturn(GetProductResponse())
            }
            .compactMap {
                $0?.products
            }
        
        Observable.combineLatest(getMenu, getProduct)
            .do(onNext: {(menus, products) in
                self.processApiResult(menus: menus, products: products)
            })
            .mapToVoid()
            .bind(to: outApiResult)
            .disposed(by: disposeBag)
    }
    
    private func processApiResult(menus: [MerchantMenu], products: [MerchantProduct]) {
        sectionedProductList = Dictionary(grouping: products, by: { $0.tagId ?? -1 })
        self.menuList = menus
    }
    
    
    func getProductOfSection(_ section: Int) -> [MerchantProduct] {
        if let menuId = menuList[section - 1].id {
            return sectionedProductList[menuId] ?? []
        } else {
            return []
        }
    }
    
    func getProductAt(indexPath: IndexPath) -> MerchantProduct? {
        let productMenu = getProductOfSection(indexPath.section)
        
        if (indexPath.row < productMenu.count) {
            return productMenu[indexPath.row]
        }
        
        return nil
    }
    
    func getMenuFor(section: Int) -> MerchantMenu {
        return menuList[section - 1]
    }
    
    func needDisplayCartView() -> Bool {
        return !UserRepo.shared.cart.isCartEmpty()
    }
    
    func getNumOfItemInCart() -> Int {
        return UserRepo.shared.cart.getNumItem()
    }
    
    func getTotalPrice() -> Double {
        return UserRepo.shared.cart.getTotalPrice()
    }
    
}
