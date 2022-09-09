//
//  LoginViewModel.swift
//  FPEU
//
//  Created by son on 04/09/2022.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

class LoginViewModel: FPViewModel {
    let inLogin = PublishRelay<Void>()
    
    let inUsername = BehaviorRelay<String?>(value: nil)
    let inPassword = BehaviorRelay<String?>(value: nil)
    
    let outHasLoggedInSuccess = PublishRelay<Bool>()
    let outErrorLogin = BehaviorSubject<String?>(value: nil)
    
    var outEnableLoginButton: Observable<Bool> {
        Observable.combineLatest(inUsername, inPassword) {username, password in
            
            guard let username = username, let password = password else {
                return false
            }
            
            return username.isNotEmpty && password.isNotEmpty && password.count >= 6
        }
    }
    
    override init() {
        super.init()
        setupBinings()
    }
    
    private func setupBinings() {
        inLogin.flatMapLatest {
            FPNetwork.singlePost(endpoint: Endpoint.login, params: [
                "username": self.inUsername.value ?? "",
                "password": self.inPassword.value ?? ""
            ])
        }
        .map {loginResponse in
            self.processResponse(loginResponse)
        }
        .bind(to: outHasLoggedInSuccess)
        .disposed(by: disposeBag)
    }
    
    private func processResponse(_ loginResponse: LoginResponse?) -> Bool {
        guard let loginResponse = loginResponse else {
            self.errorDescription.onNext("Có lỗi xảy ra, vui lòng thử lại sau.")
            return false
        }
        
        if (loginResponse.code == "0") {
            saveUserLoginInfo(loginResponse)
            return true
        } else {
            self.outErrorLogin.onNext(loginResponse.msg)
            return false
        }
        
    }
    
    private func saveUserLoginInfo(_ loginResponse: LoginResponse) {
        UserDataDefaults.shared.isLoggedIn = true
        UserDataDefaults.shared.jwtToken = loginResponse.jwtToken
    }
}
