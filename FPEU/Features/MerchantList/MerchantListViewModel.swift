//
//  MerchantListViewModel.swift
//  FPEU
//
//  Created by son on 07/11/2022.
//

import Foundation
import RxSwift
import RxRelay

class MerchantListViewModel: FPViewModel {
    
    private let triggerLoadMerchant = PublishRelay<Void>()
    
    var searchKey: String?
    var currentPage = 0
    let pageSize = 10
    var categoryId: Int?
    var lastGetCount = 0
    
    private (set) var merchantList: [MerchantItem] = []
    
    struct Input {
        let categoryId: Int?
        let loadMoreTrigger: PublishRelay<Void>
        let searchTextTrigger: PublishRelay<String?>
    }
    
    public struct Output {
        let loadDataDone: PublishRelay<Void>
        let loadMore: PublishRelay<Void>
    }
    
    public func transform(input: Input) -> Output {
        let listMerchantRelay = PublishRelay<Void>()
        let loadMore = PublishRelay<Void>()
        
        
        self.categoryId = input.categoryId
        
        input.loadMoreTrigger
            .filter {
                return self.canLoadMore()
            }
            .do(onNext: {
                self.currentPage+=1
            })
            .mapToVoid()
            .bind(to: triggerLoadMerchant, loadMore)
            .disposed(by: disposeBag)
        
        input.searchTextTrigger
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map{ ($0?.isEmpty ?? true) ? nil : $0 }
            .do(onNext: {searchKey in
                self.currentPage = 0
                self.merchantList.removeAll()
                self.searchKey = searchKey
            })
            .mapToVoid()
            .bind(to: triggerLoadMerchant)
            .disposed(by: disposeBag)
                
        triggerLoadMerchant
            .flatMapLatest {
                self.getListMerchant()
            }
            .do(onNext:{merchants in
                self.lastGetCount = merchants.count
                self.merchantList.append(contentsOf: merchants)
            })
            .mapToVoid()
            .bind(to: listMerchantRelay)
            .disposed(by: disposeBag)
    
        return Output(loadDataDone: listMerchantRelay, loadMore: loadMore)
    }
    
    public func canLoadMore() -> Bool {
        return merchantList.isEmpty ? true : lastGetCount == pageSize
    }
    
    private func getListMerchant() -> Observable<[MerchantItem]> {
        
        var params: [String : Any] = [
            "page": currentPage,
            "size": pageSize
        ]
        
        if let categoryId = categoryId {
            params["categoryId"] = categoryId
        }
        
        if let searchKey = searchKey, searchKey.isNotEmpty {
            params["searchKey"] = searchKey
        }
        
        return FPNetwork.singleGet(GetMerchantListResponse.self, endpoint: Endpoint.findMerchant, params: params)
            .map {response in
                response?.merchants ?? []
            }
            .asObservable()
    }
    
}
